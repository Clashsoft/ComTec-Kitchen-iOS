//
// Created by Adrian Kunz on 2019-02-28.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

extension NumberFormatter {
	static let localDecimal = NumberFormatter(style: .decimal, locale: .autoupdatingCurrent)

	static let localCurrency = currency()

	convenience init(style: NumberFormatter.Style, locale: Locale, usingGroupingSeparator: Bool = false) {
		self.init()
		self.numberStyle = style
		self.locale = locale
		self.usesGroupingSeparator = usingGroupingSeparator
	}

	fileprivate static func currency() -> NumberFormatter {
		return NumberFormatter(style: .currency, locale: .autoupdatingCurrent, usingGroupingSeparator: true)
	}
}

extension Double {
	private static let suffixes = ["", "k", "M", "B", "T", "Q" ]

	var €: String {
		return NumberFormatter.localCurrency.string(from: self as NSNumber)!
	}

	var short€: String {
		for index in stride(from: Double.suffixes.count - 1, through: 0, by: -1) {
			let power = pow(1000.0, Double(index))

			if abs(self) >= power {
				let formatter = NumberFormatter.currency()
				let suffix = Double.suffixes[index]
				formatter.positiveSuffix = suffix + formatter.positiveSuffix
				formatter.negativeSuffix = suffix + formatter.negativeSuffix
				formatter.minimumFractionDigits = 0
				formatter.maximumFractionDigits = 1
				return formatter.string(from: (self / power) as NSNumber)!
			}
		}
		return self.€
	}
}
