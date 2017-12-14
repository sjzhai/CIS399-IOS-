//
//  FruitsViewController.swift
//  W4Example
//
//  Created by Charles Augustine on 1/30/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import UIKit


class FruitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	// MARK: UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		// If numberOfSections is not implemented the default will be for the table to show 1 section, so this
		// implementation is not strictly necessary.
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return FruitService.shared.fruitNames().count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Ask the table view for a cell and configure it with the data that corresponds to the section and row
		// that are specified by the indexPath parameter.  Make sure to use the version of the dequeueReusableCell
		// method that accepts the indexPath parameter.  The other version will not work in the same way.
		let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath)

		cell.textLabel?.text = FruitService.shared.fruitNames()[indexPath.row]
		cell.detailTextLabel?.text = "Row \(indexPath.row)"

		return cell
	}

	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// This implementation is trivial, so it would be equivalent to setup the segue directly in the storyboard.
		performSegue(withIdentifier: "DetailSegue", sender: self)
	}

	// MARK: View Management
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "DetailSegue" {
			// Configure the destination view controller with information about what was selected so it can show
			// appropriate details.
			let fruitDetailViewController = segue.destination as! FruitDetailViewController
			let indexPath = fruitsTableView.indexPathForSelectedRow!
			fruitsTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
			fruitDetailViewController.selectedFruit = FruitService.shared.fruitNames()[indexPath.row]
		}
		else {
			// If the segue has an identifier that is unknown to this view controller, pass it to super.
			super.prepare(for: segue, sender: sender)
		}
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var fruitsTableView: UITableView!
}

