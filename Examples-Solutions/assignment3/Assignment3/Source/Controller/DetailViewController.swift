//
//  DetailViewController.swift
//  Assignment3
//


import UIKit


class DetailViewController : UIViewController {
	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		DetailViewController.presentationCount += 1

		presentationCountLabel.text = "Presented \(DetailViewController.presentationCount) time\(DetailViewController.presentationCount != 1 ? "s" : "")"
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var presentationCountLabel: UILabel!

	// MARK: Properties (Private Static)
	private static var presentationCount: Int = 0
}
