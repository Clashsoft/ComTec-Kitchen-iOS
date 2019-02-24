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
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
		let user = getItem(at: indexPath)

		cell.textLabel?.text = "\(user.name) (\(user.role))"
		cell.detailTextLabel?.text = "\(user.mail) | \(user.created ?? "") | \(user.credit)"

		return cell
	}
}
