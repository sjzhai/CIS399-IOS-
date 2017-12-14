//
//  Hill+CoreDataClass.swift
//  BigHills
//


import Foundation
import CoreData
import MapKit


class Hill: NSManagedObject, MKAnnotation {
	// MARK: Properties (MKAnnotation)
	var coordinate: CLLocationCoordinate2D {
		get {
			return CLLocationCoordinate2D(latitude: latitude?.doubleValue ?? 0, longitude: longitude?.doubleValue ?? 0)
		}
		set {
			do {
				try HillService.shared.updateHill(self, withLatitude: newValue.latitude, longitude: newValue.longitude, andName: name ?? "")
			}
			catch let error {
				fatalError("Failed to update existing hill: \(error)")
			}
		}
	}

	var title: String? {
		return name
	}

	var subtitle: String? {
		let numberFormatter = NumberFormatter()
		numberFormatter.formatterBehavior = .behavior10_4
		numberFormatter.minimumFractionDigits = 2
		numberFormatter.maximumFractionDigits = 5
		numberFormatter.minimumIntegerDigits = 1

		var result: String?
		if let latitude = self.latitude, let latitudeString = numberFormatter.string(from: latitude), let longitude = self.longitude, let longitudeString = numberFormatter.string(from: longitude) {
			result = "\(latitudeString), \(longitudeString)"
		}

		return result
	}
}
