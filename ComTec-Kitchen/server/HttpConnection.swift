//
// Created by Adrian Kunz on 2019-02-23.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

typealias Headers = [String: String]
typealias CompletionHandler = (Data?, Error?) -> Void

let ignoreResult: CompletionHandler = { (data, error) in }

class HttpConnection {
	static func get(url: URL, headers: Headers, completion: @escaping CompletionHandler) {
		request(url: url, method: "GET", headers: headers, body: nil, completion: completion)
	}

	static func post(url: URL, headers: Headers, body: Data, completion: @escaping CompletionHandler) {
		request(url: url, method: "POST", headers: headers, body: body, completion: completion)
	}

	static func put(url: URL, headers: Headers, body: Data, completion: @escaping CompletionHandler) {
		request(url: url, method: "PUT", headers: headers, body: body, completion: completion)
	}

	static func delete(url: URL, headers: Headers, completion: @escaping CompletionHandler) {
		request(url: url, method: "DELETE", headers: headers, body: nil, completion: completion)
	}

	private static func request(url: URL, method: String, headers: Headers, body: Data?, completion: @escaping CompletionHandler) {
		let request = URLRequest(url: url, method: method, headers: headers, body: body)
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			completion(data, error)
		}.resume()
	}
}

extension URLRequest {
	init(url: URL, method: String, headers: Headers, body: Data?) {
		self.init(url: url)
		self.httpMethod = method
		for (key, value) in headers {
			self.addValue(value, forHTTPHeaderField: key)
		}
		if let body = body {
			self.httpBody = body
		}
	}
}

extension URL {
	static func /(lhs: URL, rhs: String) -> URL {
		return lhs.appendingPathComponent(rhs)
	}
}
