//
//  MainViewController.swift
//  Assignment3
//


import UIKit


class MainViewController : UIViewController, ModalViewControllerDelegate {
	// MARK: ModalViewControllerDelegate
	func modalViewControllerDidSelectDone(_ modalViewController: ModalViewController) {
		dismiss(animated: true)
	}

	// MARK: View Management
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowImageSegue" {
			let navigationController = segue.destination as! UINavigationController
			let modalViewController = navigationController.topViewController as! ModalViewController
			modalViewController.delegate = self
		}
		else {
			super.prepare(for: segue, sender: sender)
		}
	}
}
