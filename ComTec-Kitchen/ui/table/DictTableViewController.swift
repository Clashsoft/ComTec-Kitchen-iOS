//
// Created by Adrian Kunz on 2019-02-24.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

typealias Section<T> =  (header: String, items: [T])

class DictTableViewController<T> : UITableViewController {
	var sections: [Section<T>] = []

	private func dictSection(at section: Int) -> (header: String, items: [T]) {
		return sections[section]
	}

	func getItem(at indexPath: IndexPath) -> T {
		return dictSection(at: indexPath.section).items[indexPath.row]
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem

		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .always
			navigationController?.navigationBar.prefersLargeTitles = true
		}

		self.refreshControl = UIRefreshControl()
		self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .primaryActionTriggered)
	}

	override func viewDidAppear(_ animated: Bool) {
		self.refresh()
	}

	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		refresh()
	}

	func refresh() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		refresh {
			DispatchQueue.main.async {
				self.reload()
				self.tableView.refreshControl?.endRefreshing()
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
	}

	func reload() {
		sections = getSections()
		tableView.reloadData()
	}

	func reloadAndDeleteRow(at indexPath: IndexPath) {
		if sections[indexPath.section].items.count == 1 {
			sections = getSections()
			// deleting the last item, remove the entire section
			tableView.deleteSections([indexPath.section], with: .automatic)
		}
		else {
			sections = getSections()
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}

	func getSections() -> [Section<T>] {
		fatalError("not implemented")
	}

	func refresh(completion: @escaping () -> Void) {
		fatalError("not implemented")
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dictSection(at: section).items.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return dictSection(at: section).header
	}

	@IBAction func unwindTo(_ unwindSegue: UIStoryboardSegue) {
	}
}
