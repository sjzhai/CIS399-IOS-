//
//  BigHillsViewController.swift
//  BigHills
//


import CoreData
import MapKit
import UIKit


class BigHillsViewController: UIViewController, HillDetailViewControllerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
	// MARK: IBAction
	@IBAction private func addHill(_ sender: AnyObject) {
		performSegue(withIdentifier: "CreateHillSegue", sender:self)
	}

	@IBAction private func deleteSelectedHill(_ sender: AnyObject) {
		if let hill = mapView.selectedAnnotations.last as? Hill {
			do {
				try HillService.shared.deleteHill(hill)
			}
			catch let error {
				fatalError("Failed to delete selected hill \(error)")
			}
		}
	}

	@IBAction private func connectTheDots(_ sender: AnyObject) {
		if let somePolylineOverlay = polylineOverlay {
			mapView.remove(somePolylineOverlay)
			polylineOverlay = nil

			connectTheDotsButton.title = "Connect the Dots"
		}
		else {
			// Add the overlay
			if let visibleHills = mapView.annotations(in: mapView.visibleMapRect) as? Set<Hill> {
				if visibleHills.isEmpty {
					let alertController = UIAlertController(title: "No Hills!", message: "There are no hills on screen to connect", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					self.present(alertController, animated: true, completion: nil)
				}
				else {
					var points = visibleHills.reduce([]) { (workingPoints, element) in
						return workingPoints + [element.coordinate]
					}
					let polylineOverlay = MKPolyline(coordinates: &points, count: points.count)
					mapView.add(polylineOverlay)
					self.polylineOverlay = polylineOverlay

					connectTheDotsButton.title = "Remove Overlay"
				}
			}
		}
	}

	// MARK: IBAction (Unwind Segue)
	@IBAction private func createHillFinished(_ sender: UIStoryboardSegue) {
		// Intentionally left blank
	}

	// MARK: HillDetailViewController
	func hillDetailViewController(_ viewController: HillDetailViewController, didChange hill: Hill) {
		mapView.deselectAnnotation(hill, animated: false)
		mapView.selectAnnotation(hill, animated: false)
	}

	// MARK: MKMapViewDelegate
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let annotationView: MKAnnotationView
		if let someAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "HillAnnotation") {
			annotationView = someAnnotationView
		}
		else {
			let pinAnnotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"HillAnnotation")
			pinAnnotationView.pinTintColor = .green
			pinAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
			annotationView = pinAnnotationView
		}

		annotationView.annotation = annotation
		annotationView.canShowCallout = true
		annotationView.isDraggable = true

		return annotationView;

	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let somePolyline = overlay as! MKPolyline
		let polyLineRenderer = MKPolylineRenderer(polyline: somePolyline)
		polyLineRenderer.strokeColor = UIColor.green
		polyLineRenderer.lineWidth = 5.0
		polyLineRenderer.alpha = 0.5

		return polyLineRenderer
	}

	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if let someHill = view.annotation as? Hill {
			selectedHill = someHill

			performSegue(withIdentifier: "HillDetailSegue", sender:self)
		}
	}

	// MARK: NSFetchedResultsControllerDelegate
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		if let hill = anObject as? Hill {
			if type == .delete {
				mapView.removeAnnotation(hill)
			}
			else if type == .insert {
				mapView.addAnnotation(hill)
			}
		}
	}

	// MARK: Private
	func updateFetchedResultsController() {
		fetchedResultsController = try? HillService.shared.hillsFetchedResultsController(with: self)

		if let someObjects = fetchedResultsController?.fetchedObjects {
			mapView.addAnnotations(someObjects)
		}
	}

	// MARK: View Management
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case .some("HillDetailSegue"):
			let hillDetailViewController = segue.destination as! HillDetailViewController
			hillDetailViewController.selectedHill = selectedHill
			hillDetailViewController.delegate = self
		case .some("CreateHillSegue"):
			let navigationController = segue.destination as! UINavigationController
			let hillDetailViewController = navigationController.topViewController as! HillDetailViewController
			hillDetailViewController.updateHill(withLatitude: mapView.centerCoordinate.latitude, andLongitude: mapView.centerCoordinate.longitude)
			hillDetailViewController.delegate = self
		default:
			super.prepare(for: segue, sender: sender)
		}
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		mapView.visibleMapRect = BigHillsViewController.defaultMapRect

		updateFetchedResultsController()
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private var mapView: MKMapView!
	@IBOutlet private var connectTheDotsButton: UIBarButtonItem!

	// MARK: Properties (Private)
	private var fetchedResultsController: NSFetchedResultsController<Hill>?
	private var polylineOverlay: MKPolyline?
	private var selectedHill: Hill?

	private var observationToken: AnyObject?

	// MARK: Properties (Private Static Constant)
	private static let defaultMapRect = MKMapRect(origin: MKMapPoint(x: 41984000.0, y: 97083392.0), size: MKMapSize(width: 655360.0, height: 942080.0))
}
