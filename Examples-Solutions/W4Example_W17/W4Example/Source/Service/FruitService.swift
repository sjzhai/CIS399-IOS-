//
//  FruitService.swift
//  W4Example
//
//  Created by Charles Augustine on 2/3/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import CoreData
import Foundation


class FruitService {
	// MARK: Data Access
    // MARK: Properties (Private)
    private let fruitData: Array<Dictionary<String, Any>>
	func fruitNames() -> Array<String> {
		// Use a map operation to convert the array of dictionaries containing values into an array only containing the
		// fruit names.
		return fruitData.map { $0["FruitName"] as? String ?? "Unknown Fruit" }
        //take plist data into coredata.
        

//		// This is equivalent code using more conventional procedural style:
//		var fruitNames = Array<String>()
//		for fruitValues in fruitData {
//			if let fruitName = fruitValues["FruitName"] as? String {
//				fruitNames.append("Fruit Name")
//			}
//			else {
//				fruitNames.append("Unknown Fruit")
//			}
//		}
//
//		return fruitNames
	}

	func taxonomyValues(forFruitName fruitName: String) -> Array<String> {
		// Use the filter function to filter the array of fruit values down to the ones with the same name as the
		// parameter and then use the first function to retrieve the first object in the filtered results.  Use the ?
		// operator to pull the fruit taxonomy values from that first object if it isn't nil and attempt to cast that to
		// an array of strings.  Use the ?? operator to provide an empty array if the first object was nil or the cast
		// failed (i.e., if anything anythin made the expression turn out as nil).
		return fruitData.filter({ ($0["FruitName"] as? String) == fruitName }).first?["FruitTaxonomy"] as? Array<String> ?? []

//		// This is equivalent code using more conventional procedural style:
//		var filteredFruitData: Array<Dictionary<String, Any>>
//		for fruitValues in fruitData {
//			if fruitValues["FruitName"] == fruitName {
//				filteredFruitData.append(fruitValues)
//			}
//		}
//
//		let result: Array<String>
//		if filteredFruitData.count > 0 {
//			let fruitValues = filteredFruitData[0]
//			if let taxonomyValues = fruitValues["FruitTaxonomy"] as? Array<String> {
//				result = taxonomyValues
//			}
//			else {
//				result = []
//			}
//		}
//		else {
//			result = []
//		}
//
//		return result
	}

	// MARK: Initialization
	// This init method is marked as private so that nothing can instantiate FruitService directly.  Instead using the
	// shared static property to access a shared "singleton" instance.
	private init() {
        persistentContainer = NSPersistentContainer(name: "Model");
		let path = Bundle.main.path(forResource: "fruits", ofType: "plist")!
        
		fruitData = NSArray(contentsOfFile: path) as! Array<Dictionary<String, Any>>
	}

	
    private let persistentContainer: NSPersistentContainer;
	// MARK: Propertis (Static Constant)
	static let shared = FruitService()
}
