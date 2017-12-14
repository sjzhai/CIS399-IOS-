//
//  FruitService.swift
//  W5Example
//
//  Created by Charles Augustine on 2/3/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import CoreData
import Foundation


class FruitService {
	// MARK: Data Access
	func fruits() -> NSFetchedResultsController<Fruit> {
		// The English sentence that describes this NSFetchRequest is "Retrieve all Fruit objects sorted by name from
		// A - Z.".

		// Create an NSFetchRequest for Fruit objects.  We cannot use type inference here, because there are multiple
		// methods of the same name that return different types.  If we omit the type, there will be a compiler error
		// about ambiguous usage.
		let fetchRequest: NSFetchRequest<Fruit> = Fruit.fetchRequest()

		// Setup the fetch request to sort by name.  Fetch requests to be used in fetched results controllers must sort
		// by something.
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

		return fetchedResultsController(for: fetchRequest)
	}

	func taxonomyValues(for fruit: Fruit) -> NSFetchedResultsController<Taxonomy> {
		// The English sentence that describes this NSFetchRequest is "Retrieve all Taxonomy objects for fruit sorted by
		// their orderIndex value starting at zero.".

		// Create an NSFetchRequest for Fruit objects.  We cannot use type inference here, because there are multiple
		// methods of the same name that return different types.  If we omit the type, there will be a compiler error
		// about ambiguous usage.
		let fetchRequest: NSFetchRequest<Taxonomy> = Taxonomy.fetchRequest()

		// For this fetch request we only want to retrieve the Taxonomy objects whose fruit relationship is equal to the
		// fruit parameter.  We must use a predicate for this.  If we omit this predicate we get all taxonomy objects.
		fetchRequest.predicate = NSPredicate(format: "fruit == %@", fruit)

		// Setup the fetch request to sort by the orderIndex value.  Fetch requests to be used in fetched results
		// controllers must sort by something.
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]

		return fetchedResultsController(for: fetchRequest)
	}

	// MARK: Private
	func fetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
		// This method just creates a fetched results controller for a fetch request, converting the error into a fatal
		// error.  Since this is common code it is good practice to place it in a method rather than copy/pasting it.
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
	// This init method is marked as private so that nothing can instantiate FruitService directly.  Instead using the
	// shared static property to access a shared "singleton" instance.
	private init() {
		// Create the NSPersistentContainer.  If you wish to use the default configuration (which is sufficient for this
		// app and assignment 5), you only need to pass a name here that matches the data model file in the project.
		persistentContainer = NSPersistentContainer(name: "Model")

		// The loadPersistentStores(completionHandler:) method will load any pre-existing databases for the persistent
		// container, creating them if need be.  This is done asynchronously and the completionHandler closure is
		// executed once it has finished.  The completion handler is where you should put CoreData initialization code.
		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			// A managed object context is needed to interact with CoreData.  The persistentContainer provides one to be
			// used by the user interface named viewContext.  You can also create new contexts for work you wish to do
			// in the background by calling the newBackgroundContext() function.
			let context = self.persistentContainer.viewContext

			// Make sure to do your data manipulation inside a closure passed to perform to guarantee that CoreData.
			// This is required for CoreData to function correctly.  The one exception to this is if you know that your
			// code is running on the main queue and the context has a main queue concurrency type.
			context.perform {
				// Create a fetch request for Fruit objects and use the context to retrieve the number of fruit objects
				// that exist
				let fruitFetchRequest: NSFetchRequest<Fruit> = Fruit.fetchRequest()
				let count = try! context.count(for: fruitFetchRequest)

				// If no fruit objects exist initialize the data in CoreData based on the fruits plist data, otherwise
				// return.
				guard count == 0 else {
					return
				}

				let fruitDataPath = Bundle.main.path(forResource: "fruits", ofType: "plist")!
				let fruitData = NSArray(contentsOfFile: fruitDataPath) as! Array<Dictionary<String, AnyObject>>

				for fruitValues in fruitData {
					let fruit = Fruit(context: context)
					let name = fruitValues["FruitName"] as! String
					fruit.name = name

					let taxonomyValues = fruitValues["FruitTaxonomy"] as! Array<String>
					for someTaxonomyValue in taxonomyValues.enumerated() {
						let taxonomy = Taxonomy(context: context)
						taxonomy.value = someTaxonomyValue.element
						taxonomy.orderIndex = Int32(someTaxonomyValue.offset)

						// If the inverse relationship is setup correctly in the data model, you only need to set one
						// side of the relationship.  CoreData will manage the other side for you.
						taxonomy.fruit = fruit
					}
				}

				// If you forget to save.  Make sure to save.
				try! context.save()
			}
		})
	}

	// MARK: Private
	private let persistentContainer: NSPersistentContainer

	// MARK: Propertis (Static Constant)
	static let shared = FruitService()
}
