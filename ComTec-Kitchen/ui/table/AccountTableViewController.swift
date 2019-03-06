//
// Created by Adrian Kunz on 2019-02-25.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

class AccountTableViewController: RefreshableTableViewController {
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

		for label in [amountLabel, creditLabel, totalLabel,
		              nameLabel, mailLabel, idLabel, createdLabel] {
			label?.text = "..."
		}
	}

	// --------------- Refresh ---------------

	override func refresh(completion: @escaping () -> Void) {
		// duplicate call to completion is deliberate
		Session.shared.refreshLoggedInUser(completion: completion)
		Purchases.shared.refreshMine(completion: completion)
	}

	override func reload() {
		guard let user = Session.shared.getLoggedInUser()
		else {
			// cancels Purchase info collection too, but ok since that wouldn't work without the User anyway
			return
		}

		let myPurchases = Purchases.shared.getMine()

		self.amountLabel.text = "\(myPurchases.totalAmount)"
		self.creditLabel.text = user.credit.short€
		self.totalLabel.text = myPurchases.totalPrice.short€

		self.nameLabel.text = user.name
		self.mailLabel.text = user.mail
		self.idLabel.text = user._id
		self.createdLabel.text = user.created
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
