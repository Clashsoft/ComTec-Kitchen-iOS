//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

struct User: Codable {
	var _id: String!
	var name: String
	var mail: String
	var role: String
	var created: String!
	var token: String!
	var credit: Double
}
