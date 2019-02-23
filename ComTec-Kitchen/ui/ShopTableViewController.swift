//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class ShopTableViewController: UITableViewController {
	var items: [String:[Item]] = [:]

	private func itemSection(at section: Int) -> (header: String, items: [Item]) {
		let (key, value) = items[items.index(items.startIndex, offsetBy: section)]
		return (header: key, items: value)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.leftBarButtonItem = self.editButtonItem

		Items.shared.refreshAll() {
			DispatchQueue.main.async {
				self.items = Items.shared.getGrouped()
				self.tableView.reloadData()
			}
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemSection(at: section).items.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return itemSection(at: section).header
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
		let item = itemSection(at: indexPath.section).items[indexPath.row]

		cell.textLabel?.text = item.name
		cell.detailTextLabel?.text = "\(item.amount) available for \(item.price) €"

		return cell
	}
}
