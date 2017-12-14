//
//  FruitsViewController.swift
//  W8Example
//
//  Created by Charles Augustine on 1/30/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import CoreData
import UIKit


class FruitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: IBAction
	@IBAction private func refresh(sender: AnyObject) {
		FruitService.shared.refreshData()
	}

	// MARK: UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		// In the case that we encounter a nil value, we provide a default value of 0
		return fruitFetchedResultsController.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// In the case that we encounter a nil value, we provide a default value of 0
		return fruitFetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Ask the table view for a cell and configure it with the object that the fetched results controller returns
		// for the indexPath.  Make sure to use the version of the dequeueReusableCell method that accepts the indexPath
		// parameter.  The other version will not work in the same way.
		let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath)

		let fruit = fruitFetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = fruit.name
		cell.detailTextLabel?.text = "Row \(indexPath.row)"

		return cell
	}

	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// This implementation is trivial, so it would be equivalent to setup the segue directly in the storyboard.  You
		// should not do both, as this will cause a double segue and potentially a crash depending on how your prepare
		// for segue method is implemented.
		performSegue(withIdentifier: "DetailSegue", sender: self)
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		// There are additional methods in this delegate protocol that can be used for more detailed updates, for this
		// simple app we can just reload the entire table for any content change.
		fruitsTableView.reloadData()
	}

	// MARK: View Management
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "DetailSegue" {
			// Configure the destination view controller with information about what was selected so it can show
			// appropriate details.
			let fruitDetailViewController = segue.destination as! FruitDetailViewController
			let indexPath = fruitsTableView.indexPathForSelectedRow!
			fruitsTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
			fruitDetailViewController.selectedFruit = fruitFetchedResultsController?.object(at: indexPath)
		}
		else {
			// If the segue has an identifier that is unknown to this view controller, pass it to super.
			super.prepare(for: segue, sender: sender)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Retrieve the fetched results controller from the fruit service to prevent unnecessary creation of multiple
		// fetches
		fruitFetchedResultsController = FruitService.shared.fruits()

		// Set the delegate to self so that we can respond to updates in the data
		fruitFetchedResultsController.delegate = self
	}

	// MARK: Properties (Private)
	// We use an implicitly unwrapped optional type because the value is not set until the view loads
	private var fruitFetchedResultsController: NSFetchedResultsController<Fruit>!

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var fruitsTableView: UITableView!
}

