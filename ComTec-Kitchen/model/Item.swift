//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

struct Item: Codable {
	static let maxPrice: Double = 1000.00

	var _id: String!
	var name: String
	var price: Double
	var amount: Int
	var kind: String
}
