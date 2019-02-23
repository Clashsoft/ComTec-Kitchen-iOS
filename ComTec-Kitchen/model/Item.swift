//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

struct Item: Codable {
	var _id: String!
	var name: String
	var price: Double
	var amount: Int
	var kind: String
}
