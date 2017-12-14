//
//  FruitDetailViewController.swift
//  W5Example
//
//  Created by Charles Augustine on 2/1/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import CoreData
import UIKit


class FruitDetailViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {
	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// When using a custom cell type, it is necessary to cast the result of the dequeueReusableCell method call
		// to the type set in the Storyboard.
		let cell = tableView.dequeueReusableCell(withIdentifier: "FruitDetailCell", for: indexPath) as! FruitDetailCell
		cell.update(for: fetchedResultsController.object(at: indexPath))

		return cell
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		taxonomyTableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		fetchedResultsController = FruitService.shared.taxonomyValues(for: selectedFruit)
	}

	// MARK: Properties
	// This property is set by the FruitsViewController to the name of the fruit that the user selected during the segue
	// that presents this view controller.  It is used to show the values that correspond to the user's selection.
	var selectedFruit: Fruit! = nil

	// MARK: Properties (Private)
	var fetchedResultsController: NSFetchedResultsController<Taxonomy>!

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var taxonomyTableView: UITableView!
}
