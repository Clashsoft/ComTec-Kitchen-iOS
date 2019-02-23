//
//  UsersTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    var users: [String: [User]] = [:]

    private func userSection(at section: Int) -> (header: String, users: [User]) {
        let (key, value) = users[users.index(users.startIndex, offsetBy: section)]
        return (header: key, users: value)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .primaryActionTriggered)

        self.refresh()
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refresh()
    }

    func refresh() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Users.shared.refreshAll() {
            DispatchQueue.main.async {
                self.users = Users.shared.getGrouped()
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSection(at: section).users.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userSection(at: section).header
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = userSection(at: indexPath.section).users[indexPath.row]

        cell.textLabel?.text = "\(user.name) (\(user.role))"
        cell.detailTextLabel?.text = "\(user.mail) | \(user.created ?? "") | \(user.credit)"

        return cell
    }
}
