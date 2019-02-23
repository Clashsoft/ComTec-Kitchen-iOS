//
//  PurchasesTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class PurchasesTableViewController: DictTableViewController<Purchase> {
	override func refresh(completion: @escaping () -> Void) {
		Purchases.shared.refreshMine(completion: completion)
	}

	override func getDict() -> [String: [Purchase]] {
		return Purchases.shared.getMineGrouped()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell", for: indexPath)
		let purchase = getItem(at: indexPath)
		let itemName = Items.shared.get(id: purchase.item_id)?.name ?? purchase.item_id

		cell.textLabel?.text = "\(itemName)"
		cell.detailTextLabel?.text = "\(purchase.created ?? "") | \(purchase.amount) * \(purchase.itemPrice.€) = \(purchase.total.€)"

		return cell
	}
}
