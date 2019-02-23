//
//  SignupViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-23.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var mailTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var adminSwitch: UISwitch!

	override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewDidAppear(_ animated: Bool) {
		if Session.shared.tryLogin() {
			self.performSegue(withIdentifier: "AutoLogin", sender: self)
		}
	}

	@IBAction func editingChanged(_ sender: UITextField) {
		let nameEntered = !(nameTextField.text ?? "").isEmpty
		let mailEntered = !(mailTextField.text ?? "").isEmpty
		submitButton.isEnabled = nameEntered && mailEntered
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SignupSubmit" {
			let name = nameTextField.text!
			let mail = mailTextField.text!
			let admin = adminSwitch.isSelected
			Session.shared.register(name: name, mail: mail, admin: admin)
		}
    }
}
