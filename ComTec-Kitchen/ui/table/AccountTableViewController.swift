//
// Created by Adrian Kunz on 2019-02-25.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

class AccountTableViewController: UITableViewController {
	// =============== Fields ===============

	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var creditLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var mailLabel: UILabel!
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var createdLabel: UILabel!

	// =============== Methods ===============

	// --------------- View Load ---------------

	override func viewDidLoad() {
		super.viewDidLoad()

		useLargeTitles()
		useRefresh()

		for label in [amountLabel, creditLabel, totalLabel,
		              nameLabel, mailLabel, idLabel, createdLabel] {
			label?.text = "..."
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		refresh()
	}

	// --------------- Refresh ---------------

	override func refresh() {
		showNetworkIndicator()

		Session.shared.refreshLoggedInUser {
			DispatchQueue.main.async {
				guard let user = Session.shared.getLoggedInUser()
				else {
					return
				}

				self.creditLabel.text = user.credit.€
				self.nameLabel.text = user.name
				self.mailLabel.text = user.mail
				self.idLabel.text = user._id
				self.createdLabel.text = user.created
			}
		}

		Purchases.shared.refreshMine {
			DispatchQueue.main.async {
				let amount = Purchases.shared.getAll().reduce(0) {
					$0 + $1.amount
				}
				let total = Purchases.shared.getAll().reduce(0) {
					$0 + $1.total
				}

				self.amountLabel.text = "\(amount)"
				self.totalLabel.text = total.€

				self.endRefreshing()
				hideNetworkIndicator()
			}
		}
	}

	// --------------- Table View ---------------

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0:
				return 1
			case 1:
				return 4
			default:
				return 0
		}
	}
}
