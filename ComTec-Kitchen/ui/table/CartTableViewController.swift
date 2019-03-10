//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class CartTableViewController: DictTableViewController<Purchase> {
	// =============== Static Methods ===============

	static func refreshBadge(_ tabBarController: UITabBarController?) {
		let empty = Cart.shared.isEmpty()
		let badgeValue = empty ? nil : "\(Cart.shared.getTotalAmount())"
		let barItem = tabBarController?.tabBar.items?[1]

		barItem?.badgeValue = badgeValue
		barItem?.image = empty ? UIImage.cart : UIImage.cartBuying
		barItem?.selectedImage = empty ? UIImage.cartFilled : UIImage.cartBuyingFilled
	}

	// =============== Methods ===============

	// --------------- View Phases ---------------

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.installItemCell()
	}

	// --------------- Buttons ---------------

	@IBAction func submitClicked(_ sender: Any) {
		let totalAmount = Cart.shared.getTotalAmount()
		if totalAmount == 0 {
			return
		}

		let total = Cart.shared.getTotal()
		let title = "cart.submit.title".localized
		let message = totalAmount == 1
			? "cart.submit.message.1".localizedFormat(total.€)
			: "cart.submit.message.n".localizedFormat(totalAmount, total.€)

		let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)

		dialog.addAction(UIAlertAction(title: "cart.submit.yes".localized, style: .default) { (_) in
			Cart.shared.submit()
			self.refresh()
		})

		dialog.addAction(UIAlertAction(title: "cart.submit.cancel".localized, style: .cancel))

		self.present(dialog, animated: true, completion: nil)
	}

	@IBAction func clearClicked(_ sender: Any) {
		let totalAmount = Cart.shared.getTotalAmount()
		if totalAmount == 0 {
			return
		}

		let title = "cart.clear.title".localized
		let message = totalAmount == 1
			? "cart.clear.message.1".localized
			: "cart.clear.message.n".localizedFormat(totalAmount)

		let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)

		dialog.addAction(UIAlertAction(title: "cart.clear.yes".localized, style: .destructive) { (_) in
			Cart.shared.clear()
			self.refresh()
		})

		dialog.addAction(UIAlertAction(title: "cart.clear.cancel".localized, style: .cancel))

		self.present(dialog, animated: true, completion: nil)
	}

	// --------------- Refresh ---------------

	override func reload() {
		super.reload()
		CartTableViewController.refreshBadge(self.tabBarController)
	}

	override func refresh(completion: @escaping () -> Void) {
		Cart.shared.refreshAll(completion: completion)
	}

	override func getSections() -> [Section<Purchase>] {
		return Cart.shared.isEmpty() ? [] : [("", Cart.shared.purchases)]
	}

	// --------------- Cell Rendering ---------------

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueItemCell(for: indexPath)
		let purchase = getItem(at: indexPath)
		let item = Items.shared.get(id: purchase.item_id)
		let itemName = item?.name ?? purchase.item_id
		let amountAvailable = item?.amount ?? 0

		cell.nameLabel.text = itemName
		cell.descriptionLabel.text = amountAvailable == 0
			? "item.available.0".localized
			: "item.available.n".localizedFormat(amountAvailable)
		cell.topRightLabel.text = "\(purchase.amount) × \(purchase.itemPrice.€)"
		cell.bottomRightLabel.text = purchase.total.€

		return cell
	}

	// --------------- Cell Deletion ---------------

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
