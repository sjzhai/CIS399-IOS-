//
//  CatService.swift
//  Assignment5
//


import CoreData


class CatService {
	// MARK: Service
	func catCategories() -> NSFetchedResultsController<Category> {
		// TODO: Update this method to utilize CoreData
//		let catDataPath = Bundle.main.path(forResource: "CatData", ofType: "plist")!
//		let catData = NSArray(contentsOfFile: catDataPath) as! Array<Dictionary<String, AnyObject>>
//		return catData.map({ ($0["CategoryTitle"] as! String, "Contains \(($0["ImageNames"] as! Array<String>).count) images") })
//        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        return fetchedResultsController(for: fetchRequest)
	}

	func images(for index: Category) -> NSFetchedResultsController<Image> {
		// TODO: Update this method to utilize CoreData
//		let catDataPath = Bundle.main.path(forResource: "CatData", ofType: "plist")!
//		let catData = NSArray(contentsOfFile: catDataPath) as! Array<Dictionary<String, AnyObject>>
//		return catData[index]["ImageNames"] as! Array<String>
        
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "image == %@", index)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
        
        return fetchedResultsController(for: fetchRequest)
	}
    
    func fetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        
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
			

			// TODO: Store the cat data in CoreData if necessary
            let context = self.persistentContainer.viewContext
            context.perform {
                
                let catFetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
                let count = try! context.count(for: catFetchRequest)
                
                guard count == 0 else {
                    return
                }
                
                let catDataPath = Bundle.main.path(forResource: "CatData", ofType: "plist")!
                let catData = NSArray(contentsOfFile: catDataPath) as! Array<Dictionary<String, AnyObject>>
                
                for catValues in catData {
                    let cat = Category(context: context)
                    let name = catValues["CategoryTitle"] as! String
                    cat.title = name
                    
                    let CatImageValues = catValues["ImageNames"] as! Array<String>
                    for someCatValue in CatImageValues.enumerated() {
                        let picture = Image(context: context)
                        picture.imagename = someCatValue.element
                        picture.value = Int32(someCatValue.offset)
                        
                        picture.image = cat
                    }
                }
                
                try! context.save()
            }
            
		})
	}

	// MARK: Private
	private let persistentContainer: NSPersistentContainer

	// MARK: Properties (Static)
	static let shared = CatService()
}
