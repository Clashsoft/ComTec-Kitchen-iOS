//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class ShopTableViewController: DictTableViewController<Item> {
	// =============== Methods ===============

	// --------------- View Load ---------------

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.installItemCell()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		tableView.allowsSelectionDuringEditing = true
		if Session.shared.isAdmin() {
			navigationItem.leftBarButtonItem = editButtonItem
		}
		else {
			navigationItem.rightBarButtonItem = nil
		}
	}

	// --------------- Refresh ---------------

	override func refresh(completion: @escaping () -> Void) {
		Items.shared.refreshAll(completion: completion)
	}

	override func getDict() -> [String: [Item]] {
		return Items.shared.getGrouped()
	}

	// --------------- Cell Rendering ---------------

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueItemCell(for: indexPath)
		let item = getItem(at: indexPath)

		cell.nameLabel.text = item.name
		cell.descriptionLabel.text = "\(item.amount) available"
		cell.topRightLabel.text = item.price.€
		cell.bottomRightLabel.text = ""

		return cell
	}

	// --------------- Cell Selection ---------------

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing {
			self.performSegue(withIdentifier: "EditItem", sender: self)
			return
		}

		tableView.deselectRow(at: indexPath, animated: false)
		let item = getItem(at: indexPath)

		if Cart.shared.add(item: item) > 0 {
			CartTableViewController.refreshBadge(self.tabBarController)
		}
	}

	// --------------- Navigation ---------------

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		if segue.identifier == "EditItem",
		   let target = segue.destination as? EditItemTableViewController,
		   let selectedRow = tableView.indexPathForSelectedRow {
			target.item = getItem(at: selectedRow)
		}
	}

	@IBAction override func unwindTo(_ segue: UIStoryboardSegue) {
		if segue.identifier == "SaveUnwind" {
			dict = getDict()
			if let indexPath = tableView.indexPathForSelectedRow {
				tableView.reloadRows(at: [indexPath], with: .automatic)
			}
			else {
				tableView.reloadData()
			}
		}
	}
}

extension Double {
	var €: String {
		return String(format: "%.2f €", self)
	}
}
