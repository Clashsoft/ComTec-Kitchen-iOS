//
//  ItemTableViewCell.swift
//  ComTec-Kitchen
//
//  Created by Adrian Kunz on 2019-02-24.
//  Copyright © 2019 Clashsoft. All rights reserved.
//

import UIKit

extension UINib {
	static let itemCell = UINib(nibName: "ItemCell", bundle: nil)
}

class ItemTableViewCell: UITableViewCell {
	static let height: CGFloat = 60

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var topRightLabel: UILabel!
	@IBOutlet weak var bottomRightLabel: UILabel!
}

extension UITableView {
	func installItemCell() {
		register(.itemCell, forCellReuseIdentifier: "ItemCell")
		rowHeight = ItemTableViewCell.height
		estimatedRowHeight = ItemTableViewCell.height
	}

	func dequeueItemCell(for indexPath: IndexPath) -> ItemTableViewCell {
		return dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
	}
}
