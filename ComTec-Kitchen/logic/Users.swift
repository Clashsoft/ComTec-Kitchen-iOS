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
			}
			completion?()
		}
	}

	func refresh(user: User, completion: (() -> Void)? = nil) {
		api.getUser(id: user._id) { (data, error) in
			if let json = data, let user = JSONTranslator.json2user(json: json) {
				self.updateLocal(user: user)
			}
			completion?()
		}
	}

	func update(user: User, completion: (() -> Void)? = nil) {
		guard let json = JSONTranslator.user2json(user: user) else {
			return
		}

		api.updateUser(id: user._id, json: json) { (_, _) in
			self.updateLocal(user: user)
			completion?()
		}
	}

	func delete(user: User, completion: (() -> Void)? = nil) {
		api.deleteUser(id: user._id) { (_, _) in
			self.deleteLocal(user: user)
			completion?()
		}
	}
}

extension Sequence where Element == User {
	func sectioned() -> [Section<User>] {
		let grouped: [String: [User]] = Dictionary(grouping: self) { (user: User) in
			String(user.name.first ?? "#").uppercased()
		}
		let sorted: [(String, [User])] = grouped.sorted {
			$0.key < $1.key
		}
		return sorted.map {
			(header: $0.0, items: $0.1.sorted {
				$0.name < $1.name
			})
		}
	}
}
