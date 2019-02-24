//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Purchases {
	// =============== Static Fields ===============

	static let shared = Purchases()

	// =============== Fields ===============

	let api = KitchenAPI.shared

	var purchases: [String:Purchase] = [:]

	// =============== Methods ===============

	// --------------- Access ---------------

	func getAll() -> [Purchase] {
		return Array(purchases.values)
	}

	func getMine() -> [Purchase] {
		guard let user = Session.shared.getLoggedInUser() else {
			return []
		}
		let userId = user._id
		return Array(purchases.values.filter { $0.user_id == userId })
	}

	func getMineSectioned() -> [Section<Purchase>] {
		let grouped: [String: [Purchase]] = Dictionary(grouping: getMine()) { (purchase: Purchase) in
			guard let created = purchase.created
			else {
				return ""
			}
			return String(created[..<created.index(created.startIndex, offsetBy: 10)])
		}
		let sorted: [(String, [Purchase])] = grouped.sorted {
			$0.key < $1.key
		}
		return sorted.map {
			(header: $0.0, items: $0.1.sorted {
				$0.created < $1.created
			})
		}
	}

	// --------------- Modification ---------------

	func updateLocal(purchase: Purchase) {
		purchases[purchase._id] = purchase
	}

	// --------------- Communication ---------------

	func refreshAll(completion: (() -> Void)? = nil) {
		api.getAllPurchases { (data, error) in
			if let json = data, let purchases = JSONTranslator.json2purchases(json: json) {
				purchases.forEach(self.updateLocal)
				completion?()
			}
		}
	}

	func refreshMine(completion: (() -> Void)? = nil) {
		api.getMyPurchases { (data, error) in
			if let json = data, let purchases = JSONTranslator.json2purchases(json: json) {
				purchases.forEach(self.updateLocal)
				completion?()
			}
		}
	}
}
