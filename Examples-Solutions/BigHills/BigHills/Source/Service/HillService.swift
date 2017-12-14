//
//  HillService.swift
//  BigHills
//


import CoreData
import Foundation


class HillService {
	// MARK: Service
	func hillsFetchedResultsController(with delegate: NSFetchedResultsControllerDelegate?) throws -> NSFetchedResultsController<Hill> {
		let fetchRequest: NSFetchRequest<Hill> = Hill.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

		let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		resultsController.delegate = delegate

		try resultsController.performFetch()
		return resultsController
	}

	func createHill(withLatitude latitude: Double, longitude: Double, andName name: String) throws {
		let context = persistentContainer.viewContext

		let hill = Hill(context: context)
		hill.latitude = latitude as NSNumber
		hill.longitude = longitude as NSNumber
		hill.name = name

		try persistentContainer.viewContext.save()
	}

	func updateHill(_ hill: Hill, withLatitude latitude: Double, longitude: Double, andName name: String) throws {
		hill.latitude = latitude as NSNumber
		hill.longitude = longitude as NSNumber
		hill.name = name

		try persistentContainer.viewContext.save()
	}

	func deleteHill(_ hill: Hill) throws {
		persistentContainer.viewContext.delete(hill)
		try persistentContainer.viewContext.save()
	}

	// MARK: Initialization
	private init() {
		persistentContainer = NSPersistentContainer(name: "Model")
		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
			let context = self.persistentContainer.viewContext
			context.perform {
				let fetchRequest: NSFetchRequest<Hill> = Hill.fetchRequest()
				if (try? context.count(for: fetchRequest)) ?? 0 == 0 {
					let insertHill = { (latitude: Double, longitude: Double, name: String) -> Void in
						let hill = Hill(context: context)
						hill.latitude = latitude as NSNumber
						hill.longitude = longitude as NSNumber
						hill.name = name
					}

					insertHill(44.05868, -123.09565, "Skinner's Butte")
					insertHill(43.9817, -123.06026, "Dillard")
					insertHill(43.98312, -123.09537, "Spencer's Butte")
					insertHill(43.95745, -123.12691, "Fox Hollow")
					insertHill(43.95538, -123.137, "McBeth")
					insertHill(43.9089, -123.17167, "Hamm")
					insertHill(44.01084, -123.16948, "Bailey Hill")
					insertHill(43.96601, -123.23914, "Briggs Hill")
					insertHill(43.98158, -123.27433, "Doane")
					insertHill(44.00467, -123.32703, "Central")
					insertHill(43.92222, -123.43183, "Wolf Creek")
					insertHill(44.03661, -123.37056, "Bolton Hill")
					insertHill(44.14384, -123.33535, "Butler")
					insertHill(44.1758, -123.35353, "Smyth")
					insertHill(44.03673, -123.20832, "Green Hill")

					do {
						try context.save()
					}
					catch _ {
						fatalError("Failed to save context after inserting initial hill data")
					}
				}
			}
		})
	}

	// MARK: Private
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Static)
	static let shared = HillService()
}
