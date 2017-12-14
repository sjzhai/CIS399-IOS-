//
//  ViewController.swift
//  W3Example
//
//  Created by Charles Augustine on 1/25/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import UIKit


class RootViewController: UIViewController {
	// MARK: Initialization
	required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		// This line would crash the program, because the launchLabel property is an
		// implicitly unwrapped optional which has a nil value by default.  The value
		// is only set to a valid label when the view is loaded, which happens when
		// it is about to be shown.  The viewDidLoad method below is one of the first
		// places where it is valid to access such variables.

//		launchLabel.text = "Launched at \(Date())"
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		launchLabel.text = "Launched at \(Date())"
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var launchLabel: UILabel! = nil
}


