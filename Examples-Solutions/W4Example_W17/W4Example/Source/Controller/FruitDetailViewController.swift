//
//  FruitDetailViewController.swift
//  W4Example
//
//  Created by Charles Augustine on 2/1/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import UIKit


class FruitDetailViewController: UIViewController, UITableViewDataSource {
	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return FruitService.shared.taxonomyValues(forFruitName: selectedFruit).count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// When using a custom cell type, it is necessary to cast the result of the dequeueReusableCell method call
		// to the type set in the Storyboard.
		let cell = tableView.dequeueReusableCell(withIdentifier: "FruitDetailCell", for: indexPath) as! FruitDetailCell

		// Make sure to configure the cell with the value specific to the section and row of the indexPath parameter.
		let value = FruitService.shared.taxonomyValues(forFruitName: selectedFruit)[indexPath.row]
		cell.update(for: value)

		return cell
	}

	// MARK: Properties
	// This property is set by the FruitsViewController to the name of the fruit that the user selected during the segue
	// that presents this view controller.  It is used to show the values that correspond to the user's selection.
	var selectedFruit: String! = nil
}
