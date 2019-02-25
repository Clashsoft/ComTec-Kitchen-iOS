//
//  AccountsTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-25.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class AccountsTableViewController: UITableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Session.shared.getNumberOfAccounts()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
		let account = Session.shared.getAccount(index: indexPath.row)

		cell.textLabel?.text = account.userName

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Session.shared.selectAccount(withIndex: indexPath.row) {
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "SelectAccount", sender: self)
			}
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SelectAccount",
		   let target = segue.destination as? UITabBarController {
			target.selectedIndex = 2
		}
	}
}
