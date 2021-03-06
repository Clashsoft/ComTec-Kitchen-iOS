//
//  ShopTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class ShopTableViewController: DictTableViewController<Item> {
	// =============== Fields ===============

	@IBOutlet var addButtonItem: UIBarButtonItem!
	@IBOutlet var cameraButtonItem: UIBarButtonItem!

	// =============== Methods ===============

	// --------------- View Phases ---------------

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.installItemCell()

		// In the storyboard, both buttons are present,
		// so we remove the add button here under the assumption
		// that edit mode is initially off
		navigationItem.leftBarButtonItems = [cameraButtonItem]
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationItem.rightBarButtonItem = Session.shared.isAdmin() ? editButtonItem : nil
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if let myDelegate = UIApplication.shared.delegate as? AppDelegate,
		   let shortcutItem = myDelegate.shortcutItem,
		   shortcutItem.type == "ScanBarcode" {
			myDelegate.shortcutItem = nil
			self.performSegue(withIdentifier: "ScanItem", sender: self)
		}
	}

	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		navigationItem.leftBarButtonItem = editing ? addButtonItem : cameraButtonItem
	}

	// --------------- Left Bar Button Actions ---------------

	@IBAction func addButtonTapped(_ button: UIBarButtonItem) {
		self.performSegue(withIdentifier: "AddItem", sender: self)
	}

	@IBAction func camButtonTapped(_ button: UIBarButtonItem) {
		self.performSegue(withIdentifier: "ScanItem", sender: self)
	}

	// --------------- Refresh ---------------

	override func refresh(completion: @escaping () -> Void) {
		Items.shared.refreshAll(completion: completion)
	}

	override func getSections() -> [Section<Item>] {
		return Items.shared.getAll().sectioned()
	}

	// --------------- Cell Rendering ---------------

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueItemCell(for: indexPath)
		let item = getItem(at: indexPath)
		let cartAmount = Cart.shared.getAmount(of: item)

		cell.nameLabel.text = item.name
		cell.descriptionLabel.text = item.amount == 0
			? "item.available.0".localized
			: "item.available.n".localizedFormat(item.amount)

		switch cartAmount {
			case 0:
				cell.topRightLabel.text = item.price.€
				cell.bottomRightLabel.text = ""
			case 1:
				cell.topRightLabel.text = "1 × \(item.price.€)"
				cell.bottomRightLabel.text = ""
			default:
				cell.topRightLabel.text = "\(cartAmount) × \(item.price.€)"
				cell.bottomRightLabel.text = (Double(cartAmount) * item.price).€
		}

		return cell
	}

	// --------------- Cell Selection ---------------

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if tableView.isEditing {
			return true
		}
		else {
			let item = getItem(at: indexPath)
			return Cart.shared.getAmount(of: item) > 0
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing {
			self.performSegue(withIdentifier: "EditItem", sender: self)
		}
		else {
			let item = getItem(at: indexPath)

			tableView.deselectRow(at: indexPath, animated: false)

			if Cart.shared.add(item: item) > 0 {
				tableView.reloadRows(at: [indexPath], with: .automatic)
				CartTableViewController.refreshBadge(self.tabBarController)
			}
			else {
				guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell else {
					return
				}

				UIView.animate(withDuration: 0.2) {
					cell.descriptionLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
					cell.descriptionLabel.transform = .identity
				}
			}
		}
	}

	var editingRow: Bool = false

	override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
		editingRow = true
	}

	override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		editingRow = false
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle != .delete {
			return
		}

		let item = getItem(at: indexPath)

		if editingRow {
			if Cart.shared.remove(item: item) {
				tableView.reloadRows(at: [indexPath], with: .automatic)
				CartTableViewController.refreshBadge(self.tabBarController)
			}
		}
		else if tableView.isEditing {
			Items.shared.delete(item: item) {
				DispatchQueue.main.async {
					self.reloadAndDeleteRow(at: indexPath)
				}
			}
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
			reload()
		}
	}
}
