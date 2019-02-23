//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class CartTableViewController: DictTableViewController<Purchase> {
	override func refresh(completion: @escaping () -> Void) {
		// Cart.shared.refreshAll(completion: completion)
		completion()
	}

	override func getDict() -> [String: [Purchase]] {
		return ["": Cart.shared.purchases]
	}

	@IBAction func submitClicked(_ sender: Any) {
		let totalAmount = Cart.shared.getTotalAmount()
		if totalAmount == 0 {
			return
		}

		let total = Cart.shared.getTotal()
		let title = "Buy"
		let message = "Are you sure you want to buy \(totalAmount) item\(totalAmount == 1 ? "" : "s") for \(total.€) ?"

		let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)

		dialog.addAction(UIAlertAction(title: "Yes", style: .default) { (_) in
			Cart.shared.submit()
			self.refresh()
		})

		dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		self.present(dialog, animated: true, completion: nil)
	}

	@IBAction func clearClicked(_ sender: Any) {
		let totalAmount = Cart.shared.getTotalAmount()
		if totalAmount == 0 {
			return
		}

		let title = "Clear Cart"
		let message = "Are you sure you want to remove \(totalAmount) item\(totalAmount == 1 ? "" : "s") from the cart?"

		let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)

		dialog.addAction(UIAlertAction(title: "Yes", style: .destructive) { (_) in
			Cart.shared.clear()
			self.refresh()
		})

		dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		self.present(dialog, animated: true, completion: nil)
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath)
		let purchase = getItem(at: indexPath)
		let itemName = Items.shared.get(id: purchase.item_id)?.name ?? purchase.item_id

		cell.textLabel?.text = "\(itemName)"
		cell.detailTextLabel?.text = "\(purchase.created ?? "") | \(purchase.amount) * \(purchase.itemPrice.€) = \(purchase.total.€)"

		return cell
	}
}
