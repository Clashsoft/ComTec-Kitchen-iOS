//
// Created by Adrian Kunz on 2019-02-26.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

extension Int {
	// update when tab order changes
	static let userTabIndex = 3
}

class MainTabBarController: UITabBarController {
	private var usersController: UIViewController?

	override func viewDidLoad() {
		super.viewDidLoad()

		usersController = viewControllers?[.userTabIndex]
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let count = viewControllers?.count ?? 0

		if !Session.shared.isAdmin() {
			if count > .userTabIndex {
				viewControllers?.remove(at: .userTabIndex)
			}
		}
		else {
			if count == .userTabIndex, let usersController = usersController {
				viewControllers?.append(usersController)
			}
		}
	}
}
