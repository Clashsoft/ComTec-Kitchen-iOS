//
// Created by Adrian Kunz on 2019-03-10.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

extension String {
	var localized: String {
		return self.localized(comment: "")
	}

	func localized(comment: String) -> String {
		return NSLocalizedString(self, comment: comment)
	}

	func localizedFormat(_ args: CVarArg...) -> String {
		return String(format: self.localized, locale: .current, arguments: args)
	}
}
