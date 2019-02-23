//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Session {
	// =============== Static Fields ===============

	static let shared = Session()

	static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	static let archiveURL = documentsDirectory.appendingPathComponent("ComTec-Kitchen").appendingPathExtension("plist")

	// =============== Fields ===============

	private let api = KitchenAPI.shared
	private var userId: String?

	// =============== Methods ===============

	// --------------- Login and Signup ---------------

	func tryLogin() -> Bool {
		if !loadUserInfo() {
			return false
		}

		guard let userId = userId else {
			return false
		}

		api.getUser(id: userId) { (data, error) in
			if let json = data, let user = JSONTranslator.json2user(json: json) {
				Users.shared.updateLocal(user: user)
			}
		}
		return true
	}

	func register(name: String, mail: String, admin: Bool) {
		let role = admin ? "admin" : "user"
		let user = User(_id: nil, name: name, mail: mail, role: role, created: nil, token: nil, credit: 0)
		guard let userJson = JSONTranslator.user2json(user: user) else {
			return
		}

		(admin ? api.createAdminUser : api.createRegularUser)(userJson) { (data: Data?, error: Error?) in
			if let json = data, let resultUser = JSONTranslator.json2user(json: json) {
				self.setUserInfo(userId: resultUser._id, userToken: resultUser.token)
				self.saveUserInfo()
				Users.shared.updateLocal(user: resultUser)
			}
		}
	}

	func clearUserData() {
		setUserInfo(userId: nil, userToken: nil)
		saveUserInfo()
	}

	// --------------- Logged-In User ---------------

	func getLoggedInUser() -> User? {
		guard let userId = userId else {
			return nil
		}
		return Users.shared.get(id: userId)
	}

	func refreshLoggedInUser() {
		if let loggedInUser = getLoggedInUser() {
			Users.shared.refresh(user: loggedInUser)
		}
	}

	func isAdmin() -> Bool {
		if let loggedInUser = getLoggedInUser() {
			return loggedInUser.role == "admin"
		}
		return false
	}

	// --------------- Helpers ---------------

	private func setUserInfo(userId: String?, userToken: String?) {
		self.userId = userId
		api.userToken = userToken
	}

	private func loadUserInfo() -> Bool {
		guard let data = try? Data(contentsOf: Session.archiveURL)
		else {
			return false
		}

		let decoder = PropertyListDecoder()
		guard let properties = try? decoder.decode([String: String].self, from: data),
		      let userId = properties["userId"],
		      let userToken = properties["userToken"]
		else {
			return false
		}

		setUserInfo(userId: userId, userToken: userToken)
		return true
	}

	private func saveUserInfo() {
		let properties: [String:String]

		if let userId = self.userId, let userToken = api.userToken {
			properties = ["userId": userId, "userToken": userToken]
		}
		else {
			properties = [:]
		}

		let encoder = PropertyListEncoder()
		guard let data = try? encoder.encode(properties) else {
			return
		}

		do {
			try data.write(to: Session.archiveURL)
		}
		catch {
		}
	}
}
