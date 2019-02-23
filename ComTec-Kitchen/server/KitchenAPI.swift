//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

class KitchenAPI {
	static let USER_KEY = "QXrnDvfLLy0RdS"
	static let ADMIN_KEY = "UkQ4wtmOoWU9Ws"
	static let BASE_URL = "http://srv8.comtec.eecs.uni-kassel.de:10800/api"

	static let shared = KitchenAPI()

	var userToken: String?
	let baseURL = URL(string: BASE_URL)!

	private func headers(key: String? = nil) -> Headers {
		var headers = ["Content-Type": "application/json"]
		if let userToken = userToken {
			headers["Authorization"] = userToken
		}
		if let key = key {
			headers["key"] = key
		}
		return headers
	}

	// --------------- Server Info ---------------

	func getInfo(completion: @escaping CompletionHandler) {
		HttpConnection.get(url: baseURL, headers: headers(), completion: completion)
	}

	// --------------- Users ---------------

	func getUser(id: String, completion: @escaping CompletionHandler) {
		let url = baseURL / "users" / id
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func getAllUsers(completion: @escaping CompletionHandler) {
		let url = baseURL / "users"
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func createRegularUser(json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "users"
		HttpConnection.post(url: url, headers: headers(key: KitchenAPI.USER_KEY), body: json, completion: completion)
	}

	func createAdminUser(json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "users"
		HttpConnection.post(url: url, headers: headers(key: KitchenAPI.ADMIN_KEY), body: json, completion: completion)
	}

	func updateUser(id: String, json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "users" / id;
		HttpConnection.put(url: url, headers: headers(), body: json, completion: completion)
	}

	func deleteUser(id: String, completion: @escaping CompletionHandler) {
		let url = baseURL / "users" / id;
		HttpConnection.delete(url: url, headers: headers(), completion: completion)
	}

	// --------------- Purchases ---------------

	func getPurchase(id: String, completion: @escaping CompletionHandler) {
		let url = baseURL / "purchases" / id
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func getAllPurchases(completion: @escaping CompletionHandler) {
		let url = baseURL / "purchases"
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func getMyPurchases(completion: @escaping CompletionHandler) {
		let url = baseURL / "purchases" / "u"
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func createPurchase(json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "purchases"
		HttpConnection.post(url: url, headers: headers(), body: json, completion: completion)
	}

	func updatePurchase(id: String, json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "purchases" / id
		HttpConnection.put(url: url, headers: headers(), body: json, completion: completion)
	}

	func deletePurchase(id: String, completion: @escaping CompletionHandler) {
		let url = baseURL / "purchases" / id
		HttpConnection.delete(url: url, headers: headers(), completion: completion)
	}

	// --------------- Items ---------------

	func getItem(id: String, completion: @escaping CompletionHandler) {
		let url = baseURL / "items" / id
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func getAllItems(completion: @escaping CompletionHandler) {
		let url = baseURL / "items"
		HttpConnection.get(url: url, headers: headers(), completion: completion)
	}

	func createItem(json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "items"
		HttpConnection.post(url: url, headers: headers(), body: json, completion: completion)
	}

	func updateItem(id: String, json: Data, completion: @escaping CompletionHandler) {
		let url = baseURL / "items" / id
		HttpConnection.put(url: url, headers: headers(), body: json, completion: completion)
	}

	func deleteItem(id: String, completion: @escaping CompletionHandler) {
		let url = baseURL / "items" / id
		HttpConnection.delete(url: url, headers: headers(), completion: completion)
	}
}
