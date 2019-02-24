//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class ShopTableViewController: DictTableViewController<Item> {
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.installItemCell()
	}

	override func refresh(completion: @escaping () -> Void) {
		Items.shared.refreshAll(completion: completion)
	}

	override func getDict() -> [String: [Item]] {
		return Items.shared.getGrouped()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueItemCell(for: indexPath)
		let item = getItem(at: indexPath)

		cell.nameLabel.text = item.name
		cell.descriptionLabel.text = "\(item.amount) available"
		cell.topRightLabel.text = item.price.€
		cell.bottomRightLabel.text = ""

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		let item = getItem(at: indexPath)

		if Cart.shared.add(item: item) > 0 {
			CartTableViewController.refreshBadge(self.tabBarController)
		}
	}
}

extension Double {
	var €: String {
		return String(format: "%.2f €", self)
	}
}
