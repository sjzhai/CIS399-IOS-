//
//  Category.swift
//  Assignment6
//


import CoreData


public class Category: NSManagedObject {
	var subtitle: String {
		get {
			let count = self.images?.count ?? 0
			return "Contains \(count) image\(count == 1 ? "" : "s")"
		}
	}
}
