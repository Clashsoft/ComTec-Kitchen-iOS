//
// Created by Adrian Kunz on 2019-02-25.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Account: Codable {
	var userId: String
	var userToken: String
	var userName: String

	init(userId: String, userToken: String, userName: String) {
		self.userId = userId
		self.userToken = userToken
		self.userName = userName
	}
}
