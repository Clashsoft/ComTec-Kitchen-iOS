//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class ShopTableViewController: DictTableViewController<Item> {
	override func refresh(completion: @escaping () -> Void) {
		Items.shared.refreshAll(completion: completion)
	}

	override func getDict() -> [String: [Item]] {
		return Items.shared.getGrouped()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
		let item = getItem(at: indexPath)

		cell.textLabel?.text = item.name
		cell.detailTextLabel?.text = "\(item.amount) available for \(item.price.€)"

		return cell
	}
}

extension Double {
	var €: String {
		return String(format: "%.2f €", self)
	}
}
