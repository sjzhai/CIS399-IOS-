//
//  DishService.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/2/23.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import CoreData

class DishService {
    
    // MARK: Properties (Static)
    static let shared = DishService()
    
    private let persistentContainer: NSPersistentContainer
    
    func favoriteDishList(_ dishList: DishList, isFavorite: Bool) {
        dishList.isFavorite = isFavorite
        
        try! persistentContainer.viewContext.save()
    }
    
    func dishCategories() -> NSFetchedResultsController<DishList> {
        let fetchRequest: NSFetchRequest<DishList> = DishList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "subtitle", ascending: true)]
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func favoriteDishCategories() -> NSFetchedResultsController<DishList> {
        let fetchRequest: NSFetchRequest<DishList> = DishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func cookRecipe(for category: DishList) -> NSFetchedResultsController<Detail> {
        let fetchRequest: NSFetchRequest<Detail> = Detail.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "list == %@", category)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func presentDetail(for category: Add) -> NSFetchedResultsController<Add> {
        let fetchRequest: NSFetchRequest<Add> = Add.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "describe", ascending: true)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "ingredient", ascending: true)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "step", ascending: true)]
        return createFetchedResultsController(for: fetchRequest)
    }
    
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
    
    func addCategory(withName name: String, describe: String, ingredient: String, step: String) throws {
        let context = persistentContainer.viewContext
        
        let add = Add(context: context)
        add.name = name
        add.describe = describe
        add.ingredient = ingredient
        add.step = step
        
        do{
            try context.save()
        }catch{
            print("Error saving: \(error)")
        }
    }
    
    func makeCategories() -> NSFetchedResultsController<Add>{
        let fetchRequest: NSFetchRequest<Add> = Add.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "describe", ascending: true)]
        return createFetchedResultsController(for: fetchRequest)
        
    }
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "FinalProject")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let cookDataPath = Bundle.main.path(forResource: "CookData", ofType: "plist")!
            let cookData = NSArray(contentsOfFile: cookDataPath) as! Array<Dictionary<String, AnyObject>>
            
            let context = self.persistentContainer.viewContext
            
            context.perform {
                let fetchRequest: NSFetchRequest<DishList> = DishList.fetchRequest()
                let count = (try? context.count(for: fetchRequest)) ?? 0
                guard count == 0 else {
                    return
                }
                
                for cookele in cookData {
                    let dishlist = DishList(context: context)
                    let title = cookele["DishName"] as! String
                    dishlist.title = title
                    let subtitle = cookele["Description"] as! String
                    dishlist.subtitle = subtitle
                    
                    let url = cookele["URL"] as! String
                    dishlist.videoURL = url
                    
                    let recipelist = cookele["RecipeList"] as! Array<String>
                    for entry in recipelist.enumerated() {
                        let step = Detail(context: context)
                        step.recipe = entry.element
                        step.index = Int32(entry.offset)
                        
                        dishlist.addToContents(step)
                    }
                }
                
                do {
                    try context.save()
                }
                catch _ {
                    fatalError("Failed to save context after inserting initial data")
                }
            }
        })
    }
}
