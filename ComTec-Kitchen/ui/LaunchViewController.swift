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
		super.viewDidAppear(animated)

		// definition of tryLogin causes the weird syntax below...
		if (!Session.shared.tryLogin() {
			// ... this is executed when login was successful (tryLogin returned true)
			// but we have to wait for the load to finish before transitioning to the
			// main table -- otherwise the Users tab will not be shown even for admins
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "AutoLogin", sender: self)
			}
		}) {
			// when tryLogin returns false, the above closure is never executed,
			// but this "then" branch instead
			// (interestingly, the failure condition is determined synchronously,
			// which allows a return value in the first place)
			self.performSegue(withIdentifier: "ShowSignup", sender: self)
		}
	}
}
