//
//  ThirdViewController.swift
//  W3Example
//
//  Created by Charles Augustine on 1/27/17.
//  Copyright © 2017 Charles. All rights reserved.
//


import UIKit


class ThirdViewController : UIViewController {
	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = fancyBackgroundColor
	}

	// MARK: Properties
	var fancyBackgroundColor: UIColor = UIColor.white {
		didSet {
			if isViewLoaded {
				view.backgroundColor = fancyBackgroundColor
			}
		}
	}
}
