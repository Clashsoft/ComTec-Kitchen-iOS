//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

struct Purchase: Codable {
	var _id: String!
	var created: String!
	var user_id: String
	var item_id: String
	var amount: Int

	@available(*, deprecated, message: "Only for JSON compatibility, use itemPrice")
	var price: Double

	var itemPrice: Double {
		get {
			return total / Double(amount)
		}
		set {
			total = newValue * Double(amount)
		}
	}

	var total: Double {
		get {
			return price
		}
		set {
			price = newValue
		}
	}
}
