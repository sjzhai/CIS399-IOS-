//
//  CategoryListViewController.swift
//  LendingLibrary
//
//  Created by Charles Augustine.
//
//


import CoreData
import UIKit


class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CategoryDetailViewControllerDelegate {
	// MARK: IBAction
	@IBAction private func edit(_ sender: AnyObject) {
		categoryListTable.setEditing(true, animated: true)

		navigationItem.setLeftBarButton(doneButton, animated: true)
	}
	
	@IBAction private func done(_ sender: AnyObject) {
		categoryListTable.setEditing(false, animated: true)
		horizontalSwipeToEditMode = false

		navigationItem.setLeftBarButton(editButton, animated: true)
	}

	// MARK: UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) 
		if let someCategory = fetchedResultsController?.object(at: indexPath) {
			cell.textLabel!.text = someCategory.name
		}

		return cell
	}

	// MARK: UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// If the table is in editing mode we let the user rename the category, otherwise select the category and
		// display its lent items
		if categoryListTable.isEditing && !horizontalSwipeToEditMode {
			performSegue(withIdentifier: "CategoryDetailSegue", sender: self)
		}
		else {
			performSegue(withIdentifier: "LentItemListSegue", sender: self)
		}
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		// Since the table view is already updated, because the move input came from it being manipulated, we have to set a flag
		// so we don't try and update the table view again in the NSFetchedResultsControllerDelegate methods
		ignoreUpdates = true

		if let category = fetchedResultsController?.object(at: sourceIndexPath) {
			category.orderIndex = destinationIndexPath.row as NSNumber
			// The ranges need to be calculated not considering the above change, because it hasn't yet been saved
			if let categories = fetchedResultsController?.fetchedObjects {
				let reindexRange: NSRange
				let shiftForward: Bool
				if sourceIndexPath.row > destinationIndexPath.row {
					reindexRange = NSMakeRange(destinationIndexPath.row, sourceIndexPath.row - destinationIndexPath.row)
					shiftForward = true
				}
				else {
					reindexRange = NSMakeRange(sourceIndexPath.row + 1, destinationIndexPath.row - sourceIndexPath.row)
					shiftForward = false
				}

				let subCategories = ((categories as NSArray).subarray(with: reindexRange)) as! Array<Category>
				do {
					try LendingLibraryService.shared.reindex(subCategories, shiftForward: shiftForward)
				}
				catch {
					let alertController = UIAlertController(title: "Move Failed", message: "Failed to move category", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					present(alertController, animated: true, completion: nil)
				}

				self.ignoreUpdates = false
			}
		}
	}

	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return "Remove It!"
	}

	func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
		navigationItem.setLeftBarButton(doneButton, animated: true)

		horizontalSwipeToEditMode = true
	}

	func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
		navigationItem.setLeftBarButton(editButton, animated: true)

		horizontalSwipeToEditMode = false
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			var categoriesToReindex: Array<Category>?
			let numberOfRows = categoryListTable.numberOfRows(inSection: 0)
			if indexPath.row + 1 < numberOfRows {
				if let categories = fetchedResultsController?.fetchedObjects {
					let reindexRange = NSMakeRange(indexPath.row + 1, numberOfRows - (indexPath.row + 1))
					categoriesToReindex = ((categories as NSArray).subarray(with: reindexRange)) as? Array<Category>
				}
			}

			if let category = fetchedResultsController?.object(at: indexPath) {
				do {
					try LendingLibraryService.shared.delete(category)
					if let someCategories = categoriesToReindex {
						do {
							try LendingLibraryService.shared.reindex(someCategories, shiftForward: false)
						}
						catch _ {
							let alertController = UIAlertController(title: "Delete Failed", message: "Failed to re-order remaining categories", preferredStyle: .alert)
							alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
							self.present(alertController, animated: true, completion: nil)
						}
					}

				}
				catch _ {
					let alertController = UIAlertController(title: "Delete Failed", message: "Failed to delete category", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					present(alertController, animated: true, completion: nil)
				}
			}
		}
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if !ignoreUpdates {
			categoryListTable.beginUpdates()
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		if !ignoreUpdates {
			switch type {
			case .delete:
				categoryListTable.deleteRows(at: [indexPath!], with: .left)
			case .insert:
				categoryListTable.insertRows(at: [newIndexPath!], with: .left)
			case .move:
				categoryListTable.moveRow(at: indexPath!, to: newIndexPath!)
			case .update:
				if let cell = categoryListTable.cellForRow(at: indexPath!), let category = anObject as? Category {
					cell.textLabel!.text = category.name
				}
			}
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		if !ignoreUpdates {
			switch type {
			case .delete:
				categoryListTable.deleteSections(IndexSet(integer: sectionIndex), with: .left)
			case .insert:
				categoryListTable.insertSections(IndexSet(integer: sectionIndex), with: .left)
			default:
				print("Unexpected change type in controller:didChangeSection:atIndex:forChangeType:")
			}
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if !ignoreUpdates {
			categoryListTable.endUpdates()
		}
	}

	// MARK: CategoryDetailViewControllerDelegate
	func numberOfCategoriesForCategoryDetailViewController(_ categoryDetailViewController: CategoryDetailViewController) -> Int {
		return categoryListTable.numberOfRows(inSection: 0)
	}

	func categoryDetailViewControllerDidFinish(_ categoryDetailViewController: CategoryDetailViewController) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: Private
	private func setupResultsController() {
		fetchedResultsController = try? LendingLibraryService.shared.fetchedResultsControllerForCategoryList()
		fetchedResultsController?.delegate = self

		categoryListTable.reloadData()
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let selectedIndexPath = categoryListTable.indexPathForSelectedRow {
			categoryListTable.deselectRow(at: selectedIndexPath, animated: false)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "LentItemListSegue" {
			if let indexPath = categoryListTable.indexPathForSelectedRow, let selectedCategory = fetchedResultsController?.object(at: indexPath) {
				let lentItemListViewController = segue.destination as! LentItemListViewController
				lentItemListViewController.selectedCategory = selectedCategory

				categoryListTable.deselectRow(at: indexPath, animated: true)
			}
		}
		else if segue.identifier == "AddCategorySegue" {
			let navigationController = segue.destination as! UINavigationController
			let categoryDetailViewController = navigationController.topViewController as! CategoryDetailViewController
			categoryDetailViewController.delegate = self
		}
		else if segue.identifier == "CategoryDetailSegue" {
			if let indexPath = categoryListTable.indexPathForSelectedRow, let selectedCategory = fetchedResultsController?.object(at: indexPath) {
				let categoryDetailViewController = segue.destination as! CategoryDetailViewController
				categoryDetailViewController.selectedCategory = selectedCategory
				categoryDetailViewController.delegate = self
			}
		}
		else {
			super.prepare(for: segue, sender: sender)
		}
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.setLeftBarButton(editButton, animated: false)

		// Setting the row height to UITableViewAutomaticDimension and providing an estimatedRowHeight enables dynamic
		// cell height calculation based on the constraints in the cell's layout
		categoryListTable.rowHeight = UITableViewAutomaticDimension
		categoryListTable.estimatedRowHeight = 44.0

		setupResultsController()
	}

	// MARK: Properties (Private)
	private var horizontalSwipeToEditMode = false
	private var ignoreUpdates = false

	private var fetchedResultsController: NSFetchedResultsController<Category>?

	// MARK: Properties (IBOutlet)
	@IBOutlet private var doneButton: UIBarButtonItem!
	@IBOutlet private var editButton: UIBarButtonItem!
	@IBOutlet weak private var categoryListTable: UITableView!
}


