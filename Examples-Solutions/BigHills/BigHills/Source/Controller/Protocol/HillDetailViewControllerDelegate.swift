//
//  HillDetailViewControllerDelegate.swift
//  BigHills
//


import Foundation


protocol HillDetailViewControllerDelegate: class {
	func hillDetailViewController(_ viewController: HillDetailViewController, didChange hill: Hill)
}
