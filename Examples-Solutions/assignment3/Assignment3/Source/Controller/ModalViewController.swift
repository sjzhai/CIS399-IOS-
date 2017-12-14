//
//  ModalViewController.swift
//  Assignment3
//


import UIKit


class ModalViewController : UIViewController {
	// MARK: IBAction
	@IBAction private func done(_ sender: AnyObject) {
		delegate?.modalViewControllerDidSelectDone(self)
	}

	// MARK: Properties
	weak var delegate: ModalViewControllerDelegate?
}
