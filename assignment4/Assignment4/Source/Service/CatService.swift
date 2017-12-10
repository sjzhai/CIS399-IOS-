//
//  CatService.swift
//  Assignment4
//


import Foundation


class CatService {
	// MARK: Service
	func catCategories() -> Array<(title: String, subtitle: String)> {
		// TODO: Remove the fatalError call and return an array of tuples, where each tuple contains the title of the category and the subtitle text
		//fatalError("catCategories() not implemented")
        var array: Array<(title: String, subtitle: String)> = [];
        
        for catValues in catData {
            let catName = catValues["CategoryTitle"] as! String
            let picName = (catValues["ImageNames"] as! NSArray) as! Array<String>
            let subtitle = "Contains \(picName.count) images"
            let titleTuples:(title: String, subtitle: String) = (catName, subtitle)
            array.append(titleTuples)
        }
        if (array.count == 0){
            fatalError("catCategories() not implemented")
        }else{
            return array
        }
	}
    
	func imageNamesForCategory(atIndex index: NSInteger) -> Array<String> {
		// TODO: Remove the fatalError call and return the array of image names for the cat category specified by the index
		//fatalError("imageNamesForCategory(atIndex:) not implemented")
        let imageNames: Array<String>? = catData[index]["ImageNames"] as? Array<String>
            
        if let imageName = imageNames{
            return imageName
        }else{
            fatalError("imageNamesForCategory(atIndex:) not implemented")
        }
        
	}
    
	// MARK: Initialization
	private init() {
		let catDataPath = Bundle.main.path(forResource: "CatData", ofType: "plist")!
		catData = NSArray(contentsOfFile: catDataPath) as! Array<Dictionary<String, AnyObject>>
	}

	// MARK: Properties (Private)
	private let catData: Array<Dictionary<String, AnyObject>>

	// MARK: Properties (Static)
	static let shared = CatService()
}
