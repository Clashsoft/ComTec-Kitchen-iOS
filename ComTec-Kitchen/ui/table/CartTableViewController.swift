//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class CartTableViewController: DictTableViewController<Purchase> {
	static func refreshBadge(_ tabBarController: UITabBarController?) {
		let empty = Cart.shared.isEmpty()
		let badgeValue = empty ? nil : "\(Cart.shared.getTotalAmount())"
		let barItem = tabBarController?.tabBar.items?[1]

		barItem?.badgeValue = badgeValue
		barItem?.image = empty ? UIImage.cart : UIImage.cartBuying
		barItem?.selectedImage = empty ? UIImage.cartFilled : UIImage.cartBuyingFilled
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.installItemCell()
	}

	override func refresh(completion: @escaping () -> Void) {
		// Cart.shared.refreshAll(completion: completion)
		CartTableViewController.refreshBadge(self.tabBarController)
		completion()
	}

	override func getSections() -> [Section<Purchase>] {
		return Cart.shared.isEmpty() ? [] : [("", Cart.shared.purchases)]
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
		let cell = tableView.dequeueItemCell(for: indexPath)
		let purchase = getItem(at: indexPath)
		let item = Items.shared.get(id: purchase.item_id)
		let itemName = item?.name ?? purchase.item_id

		cell.nameLabel.text = itemName
		cell.descriptionLabel.text = "\(item?.amount ?? 0) available"
		cell.topRightLabel.text = "\(purchase.amount) × \(purchase.itemPrice.€)"
		cell.bottomRightLabel.text = purchase.total.€

		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let purchase = getItem(at: indexPath)
			Cart.shared.remove(purchase: purchase)
			reloadAndDeleteRow(at: indexPath)
			CartTableViewController.refreshBadge(tabBarController)
		}
	}
}
