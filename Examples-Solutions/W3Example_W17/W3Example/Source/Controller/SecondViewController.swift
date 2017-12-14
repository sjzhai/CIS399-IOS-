//
//  SecondViewController.swift
//  W3Example
//
//  Created by Charles Augustine on 1/27/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import UIKit


class SecondViewController : UIViewController {
	// MARK: IBAction
	@IBAction private func buttonPressed(sender: AnyObject) {
		// Only show the third view controller if the system time seconds are even
		// and show an alert otherwise.
		if Int(Date.timeIntervalSinceReferenceDate) % 2 == 1 {
			let alertController = UIAlertController(title: "Unavailable", message: "This button only works on even seconds.", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default))
			present(alertController, animated: true)
		}
		else {
			performSegue(withIdentifier: "ThirdViewControllerSegue", sender: sender)
		}
	}

	// MARK: IBAction (Unwind Segue)
	@IBAction private func done(sender: UIStoryboardSegue) {
		// This method is a special IBAction used as a destination of an unwind segue.
		// This is not how you should dismiss your modally presented view controller in
		// assignment3.  In assignment3 you should put the commented out line of code
		// shown below in your delegate method implementation in MainViewController.

//		dismiss(animated: true)
	}

	// MARK: View Management
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// The sender parameter provided to this method is what was passed to performSegue,
		// or it is the control that triggered the segue if it was not manually triggered
		if segue.identifier == "ThirdViewControllerSegue" {
			// Here we can configure the view controller(s) that are about to be presented.
			// This is an appropriate place to set any properties relevant for the function
			// of the view controllers.  A common thing to set here is the delegate of the
			// view controller being presented to self.

			// Note that the segue parameter has a destination property that allow us to get
			// the view controller about to be presented.  The properties are of type
			// UIViewController so casting is necessary to access a more specific type's
			// properties.
			let navigationController = segue.destination as! UINavigationController
			let thirdViewController = navigationController.topViewController as! ThirdViewController

			// Now that we have a reference to the view controller, set its fancyBackgroundColor
			// property to a color determined based on the system clock.
			let color: UIColor
			let timeValue = Int(Date.timeIntervalSinceReferenceDate) % 4
			switch timeValue {
			case 0:
				color = UIColor.lightGray
			case 1:
				color = UIColor.cyan
			default:
				color = UIColor.red
			}
			thirdViewController.fancyBackgroundColor = color
		}
		else {
			super.prepare(for: segue, sender: sender)
		}
	}
}
