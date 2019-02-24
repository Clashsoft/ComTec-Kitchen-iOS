//
// Created by Adrian Kunz on 2019-02-24.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation
import UIKit

extension String {
	func colored(_ color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
	}
}

extension NSAttributedString {
	static func +(lhs: String, rhs: NSAttributedString) -> NSAttributedString {
		let mut = NSMutableAttributedString(string: lhs)
		mut.append(rhs)
		return mut
	}

	static func +(lhs: NSAttributedString, rhs: String) -> NSAttributedString {
		return lhs + NSAttributedString(string: rhs)
	}

	static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
		let mut = NSMutableAttributedString(attributedString: lhs)
		mut.append(rhs)
		return mut
	}
}
