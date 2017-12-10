//
//  CatImagesViewController.swift
//  Assignment6
//


import CoreData
import UIKit


class CatImagesViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imagesFetchedResultsController.sections?.first?.numberOfObjects ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatImageCell", for: indexPath) as! CatImageCell

		let image = imagesFetchedResultsController.object(at: indexPath)
		cell.update(for: image)

		return cell
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		imagesCollectionView.reloadData()
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		imagesFetchedResultsController = CatService.shared.images(for: category)
		imagesFetchedResultsController.delegate = self
	}

	// MARK: Properties
	var category: Category! = nil

	// MARK: Properties (Private)
	private var imagesFetchedResultsController: NSFetchedResultsController<Image>!

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var imagesCollectionView: UICollectionView!
}
