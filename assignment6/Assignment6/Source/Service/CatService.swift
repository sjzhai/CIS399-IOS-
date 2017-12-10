//
//  CatService.swift
//  Assignment6
//


import CoreData


class CatService {
	// MARK: Service
	func catCategories() -> NSFetchedResultsController<Category> {
		let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

		return createFetchedResultsController(for: fetchRequest)
	}

	func images(for category: Category) -> NSFetchedResultsController<Image> {
		let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "category == %@", category)
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

		return createFetchedResultsController(for: fetchRequest)
	}

	// MARK: Private
	private func createFetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		do {
			try fetchedResultsController.performFetch()
		}
		catch let error {
			fatalError("Could not perform fetch for fetched results controller: \(error)")
		}

		return fetchedResultsController
	}

	// MARK: Initialization
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")
		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			let catDataPath = Bundle.main.path(forResource: "CatData", ofType: "plist")!
			let catData = NSArray(contentsOfFile: catDataPath) as! Array<Dictionary<String, AnyObject>>

			let context = self.persistentContainer.viewContext

			context.perform {
				let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
				let count = (try? context.count(for: fetchRequest)) ?? 0
				guard count == 0 else {
					return
				}

				for catValues in catData {
					let category = Category(context: context)
					let title = catValues["CategoryTitle"] as! String
					category.title = title

					let imageNames = catValues["ImageNames"] as! Array<String>
					for entry in imageNames.enumerated() {
						let image = Image(context: context)
						image.name = entry.element
						image.orderIndex = Int32(entry.offset)

						category.addToImages(image)
					}
				}

				do {
					try context.save()
				}
				catch _ {
					fatalError("Failed to save context after inserting initial cat data")
				}
			}
		})
	}

	// MARK: Private
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Static)
	static let shared = CatService()
}
