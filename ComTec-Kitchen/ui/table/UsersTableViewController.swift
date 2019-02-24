//
//  UsersTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class UsersTableViewController: DictTableViewController<User> {
	override func refresh(completion: @escaping () -> Void) {
		Users.shared.refreshAll(completion: completion)
	}

	override func getSections() -> [Section<User>] {
		return Users.shared.getSectioned()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
		let user = getItem(at: indexPath)

		cell.textLabel?.text = "\(user.name) (\(user.role))"
		cell.detailTextLabel?.text = "\(user.mail) | \(user.created ?? "") | \(user.credit)"

		return cell
	}
}
