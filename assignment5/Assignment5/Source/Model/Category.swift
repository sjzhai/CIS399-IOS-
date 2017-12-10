//
//  Category+CoreDataClass.swift
//  Assignment5
//
//  Created by Shengjie Zhai on 2017/2/12.
//
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    //implement a computed property that returns the subtitle for the category.
    var subtitle : String {
        get{
            return "Contains \(category!.count) items"
        }
    }
}
