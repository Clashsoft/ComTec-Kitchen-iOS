//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class JSONTranslator {
	// =============== Static Methods ===============

	private static func encode<T: Encodable>(_ value: T) -> Data? {
		return try? JSONEncoder.shared.encode(value)
	}

	private static func decode<T: Decodable>(_ type: T.Type, from json: Data) -> T? {
		return try? JSONDecoder.shared.decode(type, from: json)
	}

	// @formatter:off
	// --------------- User ---------------
	static func user2json(user: User) -> Data? { return encode(user) }
	static func json2user(json: Data) -> User? { return decode(User.self, from: json) }
	static func json2users(json: Data) -> [User]? { return decode([User].self, from: json) }
	// --------------- Item ---------------
	static func item2json(item: Item) -> Data? { return encode(item) }
	static func json2item(json: Data) -> Item? { return decode(Item.self, from: json) }
	static func json2items(json: Data) -> [Item]? { return decode([Item].self, from: json) }
	// @formatter:on
}

extension JSONDecoder {
	static let shared = JSONDecoder()
}

extension JSONEncoder {
	static let shared = JSONEncoder()
}
