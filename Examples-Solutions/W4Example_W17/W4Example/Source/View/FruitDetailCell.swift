//
//  FruitDetailCell.swift
//  W4Example
//
//  Created by Charles Augustine on 2/1/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import UIKit


class FruitDetailCell: UITableViewCell {
	// MARK: Configuration
	func update(for text: String) {
		taxonomyLabel.text = text
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var taxonomyLabel: UILabel!
}
