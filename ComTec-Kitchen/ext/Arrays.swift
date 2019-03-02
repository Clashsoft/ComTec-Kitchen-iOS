//
// Created by Adrian Kunz on 2019-03-02.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

extension Array {
	mutating func replace(by mapper: (Element) throws -> Element) rethrows {
		for i in indices {
			self[i] = try mapper(self[i])
		}
	}

	mutating func update(with mapper: (inout Element) throws -> Void) rethrows {
		for i in indices {
			try mapper(&self[i])
		}
	}
}
