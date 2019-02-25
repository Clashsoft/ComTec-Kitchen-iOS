//
//  PurchasesTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class PurchasesTableViewController: DictTableViewController<Purchase> {
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.installItemCell()
	}

	override func refresh(completion: @escaping () -> Void) {
		Purchases.shared.refreshMine(completion: completion)
	}

	override func getSections() -> [Section<Purchase>] {
		return Purchases.shared.getMine().sectioned()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueItemCell(for: indexPath)
		let purchase = getItem(at: indexPath)
		let itemName = Items.shared.get(id: purchase.item_id)?.name ?? purchase.item_id

		cell.nameLabel.text = "\(itemName)"
		cell.descriptionLabel.text = purchase.created ?? ""
		cell.topRightLabel.text = "\(purchase.amount) × \(purchase.itemPrice.€)"
		cell.bottomRightLabel.text = purchase.total.€

		return cell
	}
}
