//
//  EditUserTableViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-24.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class EditUserTableViewController: UITableViewController {
	// =============== Fields ===============

	@IBOutlet weak var saveButton: UIBarButtonItem!

	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var mailTextField: UITextField!
	@IBOutlet weak var idTextField: UITextField!
	@IBOutlet weak var createdTextField: UITextField!

	@IBOutlet weak var creditTextField: UITextField!

	var user: User!

	// =============== Methods ===============

	func readUser() -> User? {
		if let name = nameTextField.text,
		   let mail = mailTextField.text,
		   let credit = NumberFormatter.localDecimal.number(from: creditTextField.text ?? "") as? Double {
			var user = self.user!
			user.name = name
			user.mail = mail
			user.credit = credit
			return user
		}
		else {
			return nil
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		if let user = user {
			nameTextField.text = user.name
			mailTextField.text = user.mail
			idTextField.text = user._id
			createdTextField.text = user.created
			creditTextField.text = NumberFormatter.localDecimal.string(from: user.credit as NSNumber)
		}

		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}

		updateSaveButton()
	}

	// --------------- Text Field Editing ---------------

	@IBAction func editingChanged(_ sender: Any) {
		updateSaveButton()
	}

	// --------------- Save Button ---------------

	func updateSaveButton() {
		saveButton.isEnabled = readUser() != nil
	}

	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let user = readUser()
		else {
			return
		}
		Users.shared.update(user: user) {
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "SaveUnwind", sender: self)
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
			return 4
		case 1:
			return 1
		default:
			return 0
		}
	}
}
