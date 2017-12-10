//
//  CategoryListViewController.swift
//  Assignment5
//


import UIKit
import CoreData

class CategoryListViewController : UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UISearchBarDeleate
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}

	// MARK: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return catFetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath)

		let catValues = catFetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = catValues.title
		cell.detailTextLabel?.text = catValues.subtitle

		return cell
        
	}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        catListTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catFetchedResultsController = CatService.shared.catCategories()
        
        catFetchedResultsController.delegate = self
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
            let category = catFetchedResultsController.object(at:selectedIndexPath)
            catImagesViewController.categoryIndex = category

			catListTable.deselectRow(at: selectedIndexPath, animated: true)
		}
		else {
			super.prepare(for: segue, sender: sender)
		}
	}

	// MARK: Properties (Private)
	private var observerTokens = Array<Any>()
    
	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var catListTable: UITableView!
    
    private var catFetchedResultsController: NSFetchedResultsController<Category>!
}
