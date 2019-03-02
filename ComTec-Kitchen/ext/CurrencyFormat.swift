//
// Created by Adrian Kunz on 2019-02-28.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

extension NumberFormatter {
	static let localDecimal = NumberFormatter(style: .decimal, locale: .autoupdatingCurrent)

	static let localCurrency = NumberFormatter(style: .currency, locale: .autoupdatingCurrent, usingGroupingSeparator: true)

	convenience init(style: NumberFormatter.Style, locale: Locale, usingGroupingSeparator: Bool = false) {
		self.init()
		self.numberStyle = style
		self.locale = locale
		self.usesGroupingSeparator = usingGroupingSeparator
	}
}

extension Double {
	var €: String {
		return NumberFormatter.localCurrency.string(from: self as NSNumber)!
	}
}
