//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Session {
	// =============== Static Fields ===============

	static let shared = Session()

	// =============== Fields ===============

	private let api = KitchenAPI.shared

	private var preferences: Preferences!

	// =============== Properties ===============

	var userId: String? {
		return preferences?.currentAccount?.userId
	}

	// =============== Methods ===============

	// --------------- Access ---------------

	func getNumberOfAccounts() -> Int {
		return preferences?.accounts.count ?? 0
	}

	func getAccount(index: Int) -> Account {
		return preferences.accounts[index]
	}

	// --------------- Login and Signup ---------------

	func tryLogin() -> Bool {
		if let preferences = Preferences.load() {
			self.preferences = preferences
			selectAccount(withIndex: preferences.currentAccountIndex)
			return true
		}

		self.preferences = Preferences()
		return false
	}

	func register(name: String, mail: String, admin: Bool, completion: (() -> Void)? = nil) {
		let role = admin ? "admin" : "user"
		let user = User(_id: nil, name: name, mail: mail, role: role, created: nil, token: nil, credit: 0)

		guard let userJson = JSONTranslator.user2json(user: user)
		else {
			return
		}

		(admin ? api.createAdminUser : api.createRegularUser)(userJson) { (data, error) in
			if let json = data, let resultUser = JSONTranslator.json2user(json: json) {
				let account = Account(userId: resultUser._id, userToken: resultUser.token, userName: resultUser.name)

				self.preferences.accounts.append(account)
				self.preferences.currentAccountIndex = self.preferences.accounts.endIndex
				self.preferences.save()

				Users.shared.updateLocal(user: resultUser)
			}
			completion?()
		}
	}

	func selectAccount(withIndex index: Int, completion: (() -> Void)? = nil) {
		preferences.currentAccountIndex = index

		guard let currentAccount = preferences.currentAccount
		else {
			return
		}

		KitchenAPI.shared.userToken = currentAccount.userToken

		api.getUser(id: currentAccount.userId) { (data, error) in
			if let json = data, let user = JSONTranslator.json2user(json: json) {
				currentAccount.userName = user.name

				Users.shared.updateLocal(user: user)
			}

			// always save because index set above (maybe also name)
			self.preferences.save()
			completion?()
		}
	}

	// --------------- Logged-In User ---------------

	func getLoggedInUser() -> User? {
		guard let userId = userId
		else {
			return nil
		}
		return Users.shared.get(id: userId)
	}

	func refreshLoggedInUser(completion: (() -> Void)? = nil) {
		if let loggedInUser = getLoggedInUser() {
			Users.shared.refresh(user: loggedInUser, completion: completion)
		}
	}

	func isAdmin() -> Bool {
		if let loggedInUser = getLoggedInUser() {
			return loggedInUser.role == "admin"
		}
		return false
	}
}
