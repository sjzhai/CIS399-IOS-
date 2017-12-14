//
//  LentItemListViewController.swift
//  LendingLibrary
//
//  Created by Charles Augustine.
//
//


import CoreData
import UIKit


class LentItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate, LentItemDetailViewControllerDelegate {
	// MARK: IBAction
	@IBAction private func edit(_ sender: AnyObject) {
		lentItemListTable.setEditing(true, animated: true)

		navigationItem.setRightBarButton(doneButton, animated: true)
	}

	@IBAction private func done(_ sender: AnyObject) {
		lentItemListTable.setEditing(false, animated: true)
		horizontalSwipeToEditMode = false

		navigationItem.setRightBarButton(editButton, animated: true)
	}

	@IBAction private func sortLentItems(_ sender: AnyObject) {
		let alertActionHandler = { (action: UIAlertAction) -> Void in
			if let sortModeValue = action.title, let newSortMode = SortMode(rawValue: sortModeValue), newSortMode != self.sortMode {
				self.sortMode = newSortMode

				let userDefaults = UserDefaults.standard
				userDefaults.setValue(sortModeValue, forKey: LentItemListViewController.sortModeDefaultsKey)
				userDefaults.synchronize()

				self.setupResultsController()
			}
		}

		let alertController = UIAlertController(title: nil, message: "Pick a sort ordering:", preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: SortMode.borrower.rawValue, style: .default, handler: alertActionHandler))
		alertController.addAction(UIAlertAction(title: SortMode.name.rawValue, style: .default, handler: alertActionHandler))
		present(alertController, animated: true, completion: nil)
	}

	@IBAction private func addLentItem(_ sender: AnyObject) {
		performSegue(withIdentifier: "AddLentItemSegue", sender: self)
	}

	// MARK: UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController?.sections?.count ?? 0
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LentItemCell", for: indexPath)
		if let someLentItem = fetchedResultsController?.object(at: indexPath) {
			update(cell, for: someLentItem)
		}

		return cell
	}

	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// If the table is in editing mode we let the user rename the lent item, otherwise select the lent item and
		// display it
		if !lentItemListTable.isEditing && !horizontalSwipeToEditMode {
			performSegue(withIdentifier: "LentItemDetailSegue", sender: self)
		}
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if let lentItem = fetchedResultsController?.object(at: indexPath) {
				do {
					try LendingLibraryService.shared.deleteLentItem(lentItem)
				}
				catch _ {
					let alertController = UIAlertController(title: "Delete Failed", message: "There was an error deleting the lent item", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					present(alertController, animated: true, completion: nil)
				}
			}
		}
	}

	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return "Forget It!"
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		lentItemListTable.beginUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .delete:
			lentItemListTable.deleteRows(at: [indexPath!], with: .left)
		case .insert:
			lentItemListTable.insertRows(at: [newIndexPath!], with: .left)
		case .move:
			if let cell = lentItemListTable.cellForRow(at: indexPath!), let lentItem = anObject as? LentItem {
				update(cell, for: lentItem)
			}
			lentItemListTable.moveRow(at: indexPath!, to: newIndexPath!)
		case .update:
			if let cell = lentItemListTable.cellForRow(at: indexPath!), let lentItem = anObject as? LentItem {
				update(cell, for: lentItem)
			}
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .delete:
			lentItemListTable.deleteSections(IndexSet(integer: sectionIndex), with: .left)
		case .insert:
			lentItemListTable.insertSections(IndexSet(integer: sectionIndex), with: .left)
		default:
			print("Unexpected change type in controller:didChangeSection:atIndex:forChangeType:")
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		lentItemListTable.endUpdates()
	}

	// MARK: LentItemDetailViewController
	func lentItemDetailViewControllerDidFinish(_ lentItemViewController: LentItemDetailViewController) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: Private
	private func update(_ cell: UITableViewCell, for lentItem: LentItem) {
		switch sortMode {
		case .borrower:
			cell.textLabel!.text = lentItem.borrower
			cell.detailTextLabel!.text = lentItem.name
		case .name:
			cell.textLabel!.text = lentItem.name
			cell.detailTextLabel!.text = lentItem.borrower
		}
	}

	private func updateUIForSelectedCategory() {
		if let someCategory = selectedCategory {
			navigationItem.title = someCategory.name
		}

		setupResultsController()
	}

	private func setupResultsController() {
		if let someCategory = selectedCategory, let resultsController = try? LendingLibraryService.shared.fetchedResultsControllerForLentItemList(in: someCategory, using: sortMode) {
			resultsController.delegate = self
			fetchedResultsController = resultsController
		}
		else {
			fetchedResultsController = nil
		}
		lentItemListTable.reloadData()
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let selectedIndexPath = lentItemListTable.indexPathForSelectedRow {
			lentItemListTable.deselectRow(at: selectedIndexPath, animated: false)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddLentItemSegue" {
			let navigationController = segue.destination as! UINavigationController
			let lentItemDetailViewController = navigationController.topViewController as! LentItemDetailViewController
			lentItemDetailViewController.selectedCategory = selectedCategory
			lentItemDetailViewController.delegate = self
		}
		else if segue.identifier == "LentItemDetailSegue" {
			if let indexPath = lentItemListTable.indexPathForSelectedRow, let selectedLentItem = fetchedResultsController?.object(at: indexPath) {
				let lentItemDetailViewController = segue.destination as! LentItemDetailViewController
				lentItemDetailViewController.selectedCategory = selectedCategory
				lentItemDetailViewController.selectedLentItem = selectedLentItem
				lentItemDetailViewController.delegate = self
			}
		}
		else {
			super.prepare(for: segue, sender: sender)
		}

	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.setRightBarButton(editButton, animated: false)

		// Setting the row height to UITableViewAutomaticDimension and providing an estimatedRowHeight enables dynamic
		// cell height calculation based on the constraints in the cell's layout
		lentItemListTable.rowHeight = UITableViewAutomaticDimension
		lentItemListTable.estimatedRowHeight = 44.0

		let userDefaults = UserDefaults.standard
		if let sortModeValue = userDefaults.value(forKey: LentItemListViewController.sortModeDefaultsKey) as? String, let someSortMode = SortMode(rawValue: sortModeValue) {
			sortMode = someSortMode
		}

		updateUIForSelectedCategory()
	}

	// MARK: Properties
	var selectedCategory: Category! {
		didSet {
			if isViewLoaded {
				updateUIForSelectedCategory()
			}
		}
	}

	// MARK: Properties (Private)
	private var horizontalSwipeToEditMode = false

	private var sortMode = SortMode.name
	private var fetchedResultsController: NSFetchedResultsController<LentItem>?

	// MARK: Properties (IBOutlet)
	@IBOutlet private var doneButton: UIBarButtonItem!
	@IBOutlet private var editButton: UIBarButtonItem!
	@IBOutlet weak private var lentItemListTable: UITableView!

	// MARK: Properties (Private Static Constant)
	private static let sortModeDefaultsKey = "LentItemModeDefaultsKey"

	// MARK: SortMode
	enum SortMode: String {
		case borrower = "Borrower"
		case name = "Name"
	}
}
