//
//  CategoryListViewController.swift
//  Assignment6
//


import CoreData
import UIKit


class CategoryListViewController : UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UISearchBarDeleate
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}

	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoriesFetchedResultsController.sections?.first?.numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)

		let category = categoriesFetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = category.title
		cell.detailTextLabel?.text = category.subtitle

		return cell
	}

	// MARK: NSFetchedResultsController
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		// For more dynamic applications it is more appropriate to implement the other delegate methods
		// to do more fine-grained updates.  In simple cases this can be appropriate.
		catListTable.reloadData()
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		observerTokens.append(NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: OperationQueue.main, using: { [unowned self] (notification) in
			self.catListTable.adjustInsets(forWillShowKeyboardNotification: notification)
		}))

		observerTokens.append(NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: OperationQueue.main, using: { [unowned self] (notification) in
			self.catListTable.adjustInsets(forWillHideKeyboardNotification: notification)
		}))
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		for observerToken in observerTokens {
			NotificationCenter.default.removeObserver(observerToken)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "CatImagesSegue" {
			let catImagesViewController = segue.destination as! CatImagesViewController

			let selectedIndexPath = catListTable.indexPathForSelectedRow!
			catImagesViewController.category = categoriesFetchedResultsController.object(at: selectedIndexPath)

			catListTable.deselectRow(at: selectedIndexPath, animated: true)
		}
		else {
			super.prepare(for: segue, sender: sender)
		}
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		categoriesFetchedResultsController = CatService.shared.catCategories()
		categoriesFetchedResultsController.delegate = self
	}

	// MARK: Properties (Private)
	private var observerTokens = Array<Any>()
	private var categoriesFetchedResultsController: NSFetchedResultsController<Category>!

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var catListTable: UITableView!
}
