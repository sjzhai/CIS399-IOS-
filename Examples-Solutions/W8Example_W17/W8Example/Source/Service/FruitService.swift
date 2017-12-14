//
//  FruitService.swift
//  W8Example
//
//  Created by Charles Augustine on 2/3/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import CoreData
import Foundation


class FruitService {
	// MARK: Data Access
	func refreshData() {
		// Construct a URL and URLRequest
		let url = URL(string: FruitService.fruitDataURL)!
		let urlRequest = URLRequest(url: url)

		// Create a data task for the URLRequest
		let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
			// All parameters will potentially be nil depending on what occurred during the request.  Applications
			// should present potential errors to the user as appropriate.

			// Check to make sure there is no error
			guard error == nil else {
				print("Error refreshing data \(error!)")

				return
			}

			// Check to make sure the response is valid and the status code does not indicate an error
			guard let someResponse = response as? HTTPURLResponse, someResponse.statusCode >= 200, someResponse.statusCode < 300  else {
				print("Invalid response or non-200 status code")

				return
			}

			// Check to make sure there is data
			guard let someData = data else {
				return
			}

			// Check to make sure the data is JSON in the form that is expected
			guard let fruitValues = (try? JSONSerialization.jsonObject(with: someData, options: [])) as? Array<Dictionary<String, Any>> else {
				return
			}

			self.processData(fruitData: fruitValues)
		}

		// The resume() function starts the URL request.
		dataTask.resume()
	}

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

	private func processData(fruitData: Array<Dictionary<String, Any>>) {
		let context = persistentContainer.viewContext

		// Use the perform method to ensure correct CoreData access
		context.perform {
			// Fetch all existing Fruit objects so they can be updated if they exist already and deleted if they are no
			// longer in the fruitData.  The results are usually returned in an Array, but they are converted to a Set
			// here for convenience.
			let fetchRequest: NSFetchRequest<Fruit> = Fruit.fetchRequest()
			var allFruits = Set((try? context.fetch(fetchRequest)) ?? [])

			// Iterate through all the fruitValues returned from the web service and update or create CoreData as
			// appropriate
			for fruitValues in fruitData {
				// The name value will be used as a unique identifier for the Fruit objects.  Often data models have an
				// id attribute, which is ideally what would be used to identify an object uniquely.
				let name = fruitValues["FruitName"] as! String

				// Look for an existing fruit with the same name to update or create a new Fruit if nothing is found
				let existingFruit = allFruits.first(where: { $0.name == name })
				let fruit: Fruit
				if let someExistingFruit = existingFruit {
					fruit = someExistingFruit

					// Remove the fruit that will be updated from the set so we don't update it again and so it does not
					// get deleted
					allFruits.remove(someExistingFruit)
				}
				else {
					fruit = Fruit(context: context)
				}

				// Set the attributes and relationships based on the data values
				fruit.name = name

				// Delete any existing taxonomy objects and then recreate them. More complex data models might update
				// these as well
				if let taxonomyValues = fruit.taxonomyValues as? Set<Taxonomy> {
					taxonomyValues.forEach({ context.delete($0) })
				}

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

			// Delete anything remaining in allFruits, as they were no longer included in the data
			for someFruit in allFruits {
				context.delete(someFruit)
			}

			// Make sure to save the changes made.
			try! context.save()
		}
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
			self.refreshData()
		})
	}

	// MARK: Properties (Private)
	private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Private Static Constant)
	private static let fruitDataURL = "https://classes.cs.uoregon.edu/17W/cis399ios/fruit.json"

	// MARK: Properties (Static Constant)
	static let shared = FruitService()
}
