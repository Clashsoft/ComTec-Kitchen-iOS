//
// Created by Adrian Kunz on 2019-02-25.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Preferences: Codable {
	// =============== Static Fields ===============

	static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	static let archiveURL = documentsDirectory.appendingPathComponent("ComTec-Kitchen").appendingPathExtension("plist")

	// =============== Fields ===============

	var accounts: [Account] = []
	var currentAccountIndex: Int = -1

	// =============== Properties ===============

	var currentAccount: Account? {
		if accounts.indices.contains(currentAccountIndex) {
			return accounts[currentAccountIndex]
		}
		return nil
	}

	// =============== Static Methods ===============

	static func load() -> Preferences? {
		guard let data = try? Data(contentsOf: Preferences.archiveURL)
		else {
			return nil
		}

		if let accounts = try? PropertyListDecoder().decode(Preferences.self, from: data) {
			return accounts
		}
		// old format
		else if let properties = try? PropertyListDecoder().decode([String: String].self, from: data),
		        let userId = properties["userId"],
		        let userToken = properties["userToken"] {
			let accounts = Preferences()
			accounts.accounts.append(Account(userId: userId, userToken: userToken, userName: "?"))
			accounts.currentAccountIndex = 0
			return accounts
		}
		return nil
	}

	func save() {
		if accounts.count == 0 {
			// do not override potentially existing plist with useless data
			return
		}

		do {
			let data = try PropertyListEncoder().encode(self)
			try data.write(to: Preferences.archiveURL)
		}
		catch {
		}
	}
}
