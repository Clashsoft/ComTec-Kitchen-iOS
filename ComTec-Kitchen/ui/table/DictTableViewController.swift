//
// Created by Adrian Kunz on 2019-02-24.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

class DictTableViewController<T> : UITableViewController {
	var dict: [String:[T]] = [:]

	private func dictSection(at section: Int) -> (header: String, items: [T]) {
		let (key, value) = dict[dict.index(dict.startIndex, offsetBy: section)]
		return (header: key, items: value)
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
				self.dict = self.getDict()
				self.tableView.reloadData()
				self.tableView.refreshControl?.endRefreshing()
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
			}
		}
	}

	func getDict() -> [String:[T]] {
		fatalError("not implemented")
	}

	func refresh(completion: @escaping () -> Void) {
		fatalError("not implemented")
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return dict.count
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
