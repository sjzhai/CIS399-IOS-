//
//  CatImageCell.swift
//  Assignment6
//


import UIKit


class CatImageCell : UICollectionViewCell {
	// MARK: Configuration
	func update(for image: Image) {
		catImageView.image = UIImage(named: image.name!)
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var catImageView: UIImageView!
}
