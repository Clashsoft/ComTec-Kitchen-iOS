//
//  UsersTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class UsersTableViewController: DictTableViewController<User>, UISearchResultsUpdating {
	// =============== Fields ===============

	let searchController = UISearchController(searchResultsController: nil)

	// =============== Methods ===============

	// --------------- View Load ---------------

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.installItemCell()

		// Setup the Search Controller
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Users"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	// --------------- Search ---------------

	func updateSearchResults(for searchController: UISearchController) {
		sections = getSections()
		tableView.reloadData()
	}

	// --------------- Refresh ---------------

	override func refresh(completion: @escaping () -> Void) {
		Users.shared.refreshAll(completion: completion)
	}

	override func getSections() -> [Section<User>] {
		let searchText = searchController.searchBar.text ?? ""

		var users = Users.shared.getAll()
		if !searchText.isEmpty {
			users.removeAll {
				!$0.name.localizedCaseInsensitiveContains(searchText)
				&& !$0.mail.localizedCaseInsensitiveContains(searchText)
			}
		}

		return users.sectioned()
	}

	// --------------- Index ---------------

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return sections.map {
			$0.header
		}
	}

	// --------------- Cell Rendering ---------------

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueItemCell(for: indexPath)
		let user = getItem(at: indexPath)

		if user._id == Session.shared.getLoggedInUser()?._id {
			cell.nameLabel.attributedText = user.name + " me".colored(.gray)
		}
		else {
			cell.nameLabel.text = user.name
		}

		cell.descriptionLabel.text = user.mail
		cell.topRightLabel.text = user.credit.€
		cell.bottomRightLabel.text = user.role

		cell.bottomRightLabel.textColor = user.role == "admin" ? .red : .black

		return cell
	}

	// --------------- Cell Selection ---------------

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "EditUser", sender: self)
	}

	// --------------- Cell Deletion ---------------

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle != .delete {
			return
		}

		let user = getItem(at: indexPath)
		Users.shared.delete(user: user) {
			DispatchQueue.main.async {
				self.reloadAndDeleteRow(at: indexPath)
			}
		}
	}

	// --------------- Navigation ---------------

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)

		if segue.identifier == "EditUser",
		   let target = segue.destination as? EditUserTableViewController,
		   let selectedRow = tableView.indexPathForSelectedRow {
			target.user = getItem(at: selectedRow)
		}
	}

	override func unwindTo(_ segue: UIStoryboardSegue) {
		if segue.identifier == "SaveUnwind" {
			sections = getSections()
			if let indexPath = tableView.indexPathForSelectedRow {
				tableView.reloadRows(at: [indexPath], with: .automatic)
			}
		}
	}
}
