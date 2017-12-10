//
//  CatImagesViewController.swift
//  Assignment5
//


import UIKit
import CoreData

class CatImagesViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}
    
    
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell
        
        cell.update(forImageName: fetchedResultsController.object(at: indexPath))
		return cell
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = CatService.shared.images(for: categoryIndex)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        imageTableView.reloadData()
    }
    
	// MARK: Properties
	var categoryIndex: Category! = nil
    
    var fetchedResultsController: NSFetchedResultsController<Image>!
    
    @IBOutlet private weak var imageTableView: UITableView!
}
