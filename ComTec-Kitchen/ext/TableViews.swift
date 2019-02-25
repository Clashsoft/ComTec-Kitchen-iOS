//
// Created by Adrian Kunz on 2019-02-25.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

func showNetworkIndicator() {
	UIApplication.shared.isNetworkActivityIndicatorVisible = true
}

func hideNetworkIndicator() {
	UIApplication.shared.isNetworkActivityIndicatorVisible = false
}

extension UITableViewController {
	func useLargeTitles() {
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .always
			navigationController?.navigationBar.prefersLargeTitles = true
		}
	}

	func useRefresh() {
		self.refreshControl = UIRefreshControl()
		self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .primaryActionTriggered)
	}

	@objc func handleRefresh(_ control: UIRefreshControl) {
		self.refresh()
	}

	@objc func refresh() {
		fatalError("not implemented")
	}

	func endRefreshing() {
		self.tableView.refreshControl?.endRefreshing()
	}
}
