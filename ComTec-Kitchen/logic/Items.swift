//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class Items {
	// =============== Static Fields ===============

	static let shared = Items()

	// =============== Fields ===============

	private let api = KitchenAPI.shared

	private var items: [String:Item] = [:]

	// --------------- Access ---------------

	func get(id: String) -> Item? {
		return items[id]
	}

	func exists(id: String) -> Bool {
		return items.keys.contains(id)
	}

	func getAll() -> [Item] {
		return Array(items.values)
	}

	func getGrouped() -> [String:[Item]] {
		return Dictionary(grouping: items.values) { $0.kind }
	}

	// --------------- Modification ---------------

	func updateLocal(item: Item) {
		items[item._id] = item
	}

	func deleteLocal(item: Item) {
		items.removeValue(forKey: item._id)
	}

	// --------------- Communication ---------------

	func refreshAll(completion: (() -> Void)? = nil) {
		api.getAllItems { (data, error) in
			if let json = data, let items = JSONTranslator.json2items(json: json) {
				self.items.removeAll()
				items.forEach(self.updateLocal)
				completion?()
			}
		}
	}

	func create(item: Item, completion: (() -> Void)? = nil) {
		guard let itemJson = JSONTranslator.item2json(item: item) else {
			return
		}
		api.createItem(json: itemJson) { (data, error) in
			if let json = data, let item = JSONTranslator.json2item(json: json) {
				self.updateLocal(item: item)
				completion?()
			}
		}
	}

	func update(item: Item, completion: (() -> Void)? = nil) {
		guard let json = JSONTranslator.item2json(item: item) else {
			return
		}
		api.updateItem(id: item._id, json: json) { (data, error) in
			if let json = data, let item = JSONTranslator.json2item(json: json) {
				self.updateLocal(item: item)
				completion?()
			}
		}
	}

	func delete(item: Item, completion: (() -> Void)? = nil) {
		api.deleteItem(id: item._id) { (_, _) in
			self.deleteLocal(item: item)
			completion?()
		}
	}
}
