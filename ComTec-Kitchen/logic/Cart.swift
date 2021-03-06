//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Cart {
	// =============== Static Fields ===============

	static let shared = Cart()

	// =============== Fields ===============

	let api = KitchenAPI.shared

	var purchases: [Purchase] = []

	// =============== Methods ===============

	// --------------- Access ---------------

	func getPurchases() -> [Purchase] {
		return purchases
	}

	func isEmpty() -> Bool {
		return purchases.isEmpty
	}

	func getTotal() -> Double {
		return purchases.totalPrice
	}

	func getTotalAmount() -> Int {
		return purchases.totalAmount
	}

	func getAmount(of item: Item) -> Int {
		return purchases.reduce(0) {
			$0 + ($1.item_id == item._id ? $1.amount : 0)
		}
	}

	// --------------- Modification ---------------

	func clear() {
		purchases.removeAll()
	}

	func add(item: Item) -> Int {
		return add(item: item, amount: 1)
	}

	func add(item: Item, amount: Int) -> Int {
		guard let itemId = item._id
		else {
			return 0
		}

		for i in 0 ..< purchases.count {
			var purchase = purchases[i]
			if itemId != purchase.item_id {
				continue
			}

			let oldAmount = purchase.amount
			let newAmount = min(oldAmount + amount, item.amount)

			if newAmount <= 0 {
				// item no longer available, remove purchase
				purchases.remove(at: i)
				return 0
			}

			purchase.amount = newAmount
			purchase.itemPrice = item.price // update price
			purchases[i] = purchase // save
			return newAmount - oldAmount;
			// difference is how many have actually been added
		}

		let actualAmount = min(amount, item.amount)
		if actualAmount <= 0 {
			// item not available, do not add purchase
			return 0
		}

		guard let user = Session.shared.getLoggedInUser(),
		      let userId = user._id
		else {
			return 0
		}

		var purchase = Purchase(_id: nil, created: nil, user_id: userId, item_id: itemId, amount: actualAmount, price: 0)
		purchase.itemPrice = item.price
		purchases.append(purchase)
		return actualAmount
	}

	func remove(item: Item) -> Bool {
		let countBefore = purchases.count
		purchases.removeAll {
			$0.item_id == item._id
		}
		return purchases.count != countBefore
	}

	func remove(purchase: Purchase) {
		purchases.removeAll { element in
			element.item_id == purchase.item_id
		}
	}

	func updateAll() {
		// pass 1: update amount and price
		purchases.update { purchase in
			if let item = Items.shared.get(id: purchase.item_id) {
				purchase.amount = min(purchase.amount, item.amount)
				purchase.itemPrice = item.price
			}
			else {
				purchase.amount = 0
			}
		}

		// pass 2: remove invalid purchases
		purchases.removeAll {
			$0.amount <= 0
		}
	}

	// --------------- Communication ---------------

	func refreshAll(completion: (() -> Void)? = nil) {
		Items.shared.refreshAll {
			self.updateAll()
			completion?()
		}
	}

	func submit() {
		for purchase in purchases {
			if let json = JSONTranslator.purchase2json(purchase: purchase) {
				// TODO update purchases?
				api.createPurchase(json: json, completion: ignoreResult)
			}
		}

		Session.shared.refreshLoggedInUser()
		purchases.removeAll()
	}
}
