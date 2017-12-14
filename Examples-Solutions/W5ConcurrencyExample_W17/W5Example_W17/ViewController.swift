//
//  ViewController.swift
//  W5Example_W17
//
//  Created by Charles Augustine on 2/6/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import Foundation
import UIKit


class ViewController: UIViewController {
	// MARK: IBAction
	@IBAction private func performTask(_ sender: AnyObject) {
		// Start the activity indicators animation
		activityIndicator.startAnimating()

		// Dispatch some task to a global queue, which will perform the task off of the main thread where the user
		// interface is handled.  If this was not done, the UI would be unresponsive for the duration of the task.
		DispatchQueue.global().async {
			// In this example the task is just sleeping for 3 seconds, but this could be anything that would take a
			// noticeable amount of time, such as a network request.
			Thread.sleep(forTimeInterval: 3)

			// Once the task is finished we need to update the user interface, this must be done from the main thread
			// or it will not be reliable and could crash the app.  We can use the main dispatch queue to perform work
			// on the main thread.  All work done on the main queue is always done on the main thread.
			DispatchQueue.main.async {
				// Stop the activity indicator animation
				self.activityIndicator.stopAnimating()
			}
		}
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var button: UIButton!
	@IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
}

