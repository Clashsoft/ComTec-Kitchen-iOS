//
//  LaunchViewController.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-24.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
	override func viewDidAppear(_ animated: Bool) {
		if Session.shared.tryLogin() {
			self.performSegue(withIdentifier: "AutoLogin", sender: self)
		}
		else {
			self.performSegue(withIdentifier: "ShowSignup", sender: self)
		}
	}
}
