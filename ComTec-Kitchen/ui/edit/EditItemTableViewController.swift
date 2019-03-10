//
// Created by Adrian Kunz on 2019-02-24.
// Copyright (c) 2019 Clashsoft. All rights reserved.
//

import Foundation

import UIKit

class EditItemTableViewController: UITableViewController {
	// =============== Fields ===============

	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var idTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var kindTextField: UITextField!
	@IBOutlet weak var priceTextField: UITextField!
	@IBOutlet weak var amountTextField: UITextField!

	// =============== Properties ===============

	var item: Item?

	var barcode: String?

	private var edit: Bool = false

	func readItem() -> Item? {
		if let id = idTextField.text,
		   let name = nameTextField.text,
		   let kind = kindTextField.text,
		   let price = NumberFormatter.localDecimal.number(from: priceTextField.text ?? "") as? Double,
		   let amount = Int(amountTextField.text ?? ""),
		   price <= Item.maxPrice {
			return Item(_id: id, name: name, price: price, amount: amount, kind: kind)
		}
		else {
			return nil
		}
	}

	// =============== Methods ===============

	// --------------- View Phases ---------------

	override func viewDidLoad() {
		super.viewDidLoad()

		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let item = item {
			edit = true
			title = "edit_item.title".localized
			idTextField.isEnabled = false
			idTextField.textColor = .lightGray

			idTextField.text = item._id
			nameTextField.text = item.name
			kindTextField.text = item.kind
			priceTextField.text = NumberFormatter.localDecimal.string(from: item.price as NSNumber)
			amountTextField.text = "\(item.amount)"
		}
		else if let barcode = barcode {
			edit = false
			title = "add_item.title".localized
			idTextField.isEnabled = false
			idTextField.textColor = .lightGray

			idTextField.text = barcode
		}
		else {
			edit = false
			title = "add_item.title".localized
			idTextField.isEnabled = true
			idTextField.textColor = .black
		}

		updateSaveButton()
	}

	// --------------- Text Field Editing ---------------

	@IBAction func editingChanged(_ sender: Any) {
		updateSaveButton()
	}

	// --------------- Save Button ---------------

	func updateSaveButton() {
		saveButton.isEnabled = readItem() != nil
	}

	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let item = readItem()
		else {
			return
		}
		(edit ? Items.shared.update : Items.shared.create)(item) {
			DispatchQueue.main.async {
				self.performSegue(withIdentifier: "SaveUnwind", sender: self)
			}
		}
	}

	// --------------- Table View ---------------

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0:
				return 3
			case 1:
				return 2
			default:
				return 0
		}
	}
}
