//
// Created by Adrian Kunz on 2019-02-26.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

class RefreshableTableViewController: UITableViewController {
	// --------------- View Phases ---------------

	override func viewDidLoad() {
		super.viewDidLoad()

		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .primaryActionTriggered)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		reload()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		refresh()
	}

	// --------------- Refresh ---------------

	@objc func handleRefresh(_ control: UIRefreshControl) {
		refresh()
	}

	func endRefreshing() {
		tableView.refreshControl?.endRefreshing()
	}

	func refresh() {
		showNetworkIndicator()
		refresh {
			DispatchQueue.main.async {
				self.reload()
				self.endRefreshing()
				hideNetworkIndicator()
			}
		}
	}

	func refresh(completion: @escaping () -> Void) {
		fatalError("not implemented")
	}

	// --------------- Reload ---------------

	func reload() {
		fatalError("not implemented")
	}
}
