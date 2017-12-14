//
//  CategoryDetailViewControllerDelegate.swift
//  LendingLibrary
//
//  Created by Charles Augustine.
//
//


protocol CategoryDetailViewControllerDelegate: class {
	func numberOfCategoriesForCategoryDetailViewController(_ categoryDetailViewController: CategoryDetailViewController) -> Int
	func categoryDetailViewControllerDidFinish(_ categoryDetailViewController: CategoryDetailViewController)
}
