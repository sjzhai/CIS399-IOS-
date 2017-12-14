//
//  LendingLibraryService.swift
//  LendingLibrary
//
//  Created by Charles Augustine.
//
//


import CoreData
import UIKit


class LendingLibraryService {
	func fetchedResultsControllerForCategoryList() throws -> NSFetchedResultsController<Category> {
		let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
		fetchRequest.fetchBatchSize = 15

		let context = persistentContainer.viewContext
		let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		try resultsController.performFetch()

		return resultsController
	}

	func addCategory(withName name: String, andOrderIndex orderIndex: Int) throws {
		let context = persistentContainer.viewContext

		let category = Category(context: context)
		category.name = name
		category.orderIndex = orderIndex as NSNumber

		try context.save()
	}

	func renameCategory(_ category: Category, withNewName newName: String) throws {
		category.name = newName

		let context = persistentContainer.viewContext
		try context.save()
	}

	func delete(_ category: Category) throws {
		let context = persistentContainer.viewContext
		context.delete(category)

		try context.save()
	}

	func reindex(_ categories: Array<Category>, shiftForward: Bool) throws {
		for category in categories {
			let currentOrderIndex = category.orderIndex!.intValue
			if shiftForward {
				category.orderIndex = (currentOrderIndex + 1) as NSNumber
			}
			else {
				category.orderIndex = (currentOrderIndex - 1) as NSNumber
			}
		}

		let context = persistentContainer.viewContext
		try context.save()
	}

	func fetchedResultsControllerForLentItemList(in category: Category, using sortOrder: LentItemListViewController.SortMode) throws -> NSFetchedResultsController<LentItem> {
		let fetchRequest: NSFetchRequest<LentItem> = LentItem.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "category == %@", category)
		switch sortOrder {
		case .borrower:
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "borrower", ascending: true)]
		case .name:
			fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		}
		fetchRequest.fetchBatchSize = 15

		let context = persistentContainer.viewContext
		let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		try resultsController.performFetch()

		return resultsController
	}
	
	func addLentItem(withName name: String, borrower: String, borrowerID: String, dateBorrowed: Date, dateToReturn: Date, reminder: Bool, and picture: UIImage?, in category: Category) throws {
		let context = persistentContainer.viewContext
		let lentItem = LentItem(context: context)
		lentItem.name = name
		lentItem.borrower = borrower
		lentItem.borrowerID = borrowerID
		lentItem.dateBorrowed = dateBorrowed as NSDate
		lentItem.dateToReturn = dateToReturn as NSDate
		lentItem.notify = reminder as NSNumber

		if let somePicture = picture, let somePictureData = UIImageJPEGRepresentation(somePicture, 1.0) {
			let pictureEntity = Picture(context: context)
			pictureEntity.data = somePictureData as NSData
			pictureEntity.lentItem = lentItem
		}

		lentItem.category = category

		try context.save()
	}

	func update(_ lentItem: LentItem, withName name: String, borrower: String, borrowerID: String, dateBorrowed: Date, dateToReturn: Date, reminder: Bool, and picture: UIImage?) throws {
		lentItem.name = name
		lentItem.borrower = borrower
		lentItem.borrowerID = borrowerID
		lentItem.dateBorrowed = dateBorrowed as NSDate
		lentItem.dateToReturn = dateToReturn as NSDate
		lentItem.notify = reminder as NSNumber

		let context = persistentContainer.viewContext
		if let somePicture = picture, let somePictureData = UIImageJPEGRepresentation(somePicture, 1.0) {
			if let somePictureEntity = lentItem.picture {
				somePictureEntity.data = somePictureData as NSData
			}
			else {
				let pictureEntity = Picture(context: context)
				pictureEntity.data = somePictureData as NSData
				pictureEntity.lentItem = lentItem
			}
		}
		else {
			if let somePictureEntity = lentItem.picture {
				context.delete(somePictureEntity)
			}
		}

		try context.save()
	}
	
	func deleteLentItem(_ lentItem: LentItem) throws {
		let context = persistentContainer.viewContext
		context.delete(lentItem)

		try context.save()
	}

	func isInViewContext(_ object: NSManagedObject) -> Bool {
		return object.managedObjectContext == persistentContainer.viewContext
	}
	
	// MARK: Initialization
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")
		persistentContainer.loadPersistentStores(completionHandler: { (store, description) in
			// Intentionally left blank
		})
	}

	// MARK: Properties (Private)
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Static Constant)
	static let shared = LendingLibraryService()
}
