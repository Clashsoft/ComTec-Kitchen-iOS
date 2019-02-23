//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Users {
	// =============== Static Fields ===============

	static let shared = Users()

	// =============== Fields ===============

	private let api = KitchenAPI.shared

	private var users: [String:User] = [:]

	// =============== Methods ===============

	// --------------- Access ---------------

	func get(id: String) -> User? {
		return users[id]
	}

	func getAll() -> [User] {
		return Array(users.values)
	}

	func getGrouped() -> [String:[User]] {
		return Dictionary(grouping: users.values) { "\($0.name.first ?? " ")" }
	}

	// --------------- Modification ---------------

	func updateLocal(user: User) {
		users[user._id] = user
	}

	func deleteLocal(user: User) {
		users.removeValue(forKey: user._id)
	}

	// --------------- Communication ---------------

	func refreshAll(completion: (() -> Void)? = nil) {
		api.getAllUsers { (data, error) in
			if let json = data, let users = JSONTranslator.json2users(json: json) {
				self.users.removeAll()
				users.forEach(self.updateLocal)
				completion?()
			}
		}
	}

	func refresh(user: User) {
		api.getUser(id: user._id) { (data, error) in
			if let json = data, let user = JSONTranslator.json2user(json: json) {
				self.updateLocal(user: user)
			}
		}
	}

	func update(user: User) {
		guard let json = JSONTranslator.user2json(user: user) else {
			return
		}

		api.updateUser(id: user._id, json: json, completion: ignoreResult)
		updateLocal(user: user)
	}

	func delete(user: User) {
		api.deleteUser(id: user._id, completion: ignoreResult)
		deleteLocal(user: user)
	}
}