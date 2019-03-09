//
//  SignupViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
	// =============== Fields ===============

	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var mailTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var adminSwitch: UISwitch!

	// =============== Methods ===============

	override func viewDidLoad() {
		super.viewDidLoad()
		nameTextField.addTarget(mailTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
		mailTextField.addTarget(mailTextField, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
	}

	@IBAction func editingChanged(_ sender: UITextField) {
		let nameEntered = !(nameTextField.text ?? "").isEmpty
		let mailEntered = !(mailTextField.text ?? "").isEmpty
		submitButton.isEnabled = nameEntered && mailEntered
	}

	@IBAction func submitButtonTapped(_ sender: UIButton) {
		let name = nameTextField.text!
		let mail = mailTextField.text!
		let admin = adminSwitch.isOn
		Session.shared.register(name: name, mail: mail, admin: admin) {
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "SubmitSignup", sender: sender)
			}
		}
	}
}
