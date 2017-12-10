//
//  CatImagesViewController.swift
//  Assignment4
//
//  Created by Shengjie Zhai on 2017/2/5.
//
//

import UIKit

class CatImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedCatIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatService.shared.imageNamesForCategory(atIndex: selectedCatIndex).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        let a = CatService.shared.imageNamesForCategory(atIndex: selectedCatIndex)
        cell.imageView.image = UIImage(named:a[indexPath.row])
        return cell
    }
    
}
