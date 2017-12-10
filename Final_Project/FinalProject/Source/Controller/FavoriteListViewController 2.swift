//
//  FavoriteListViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/3/8.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import CoreData
import UIKit


class FavoriteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritelistFetchedResultsController = DishService.shared.favoriteDishCategories()
        favoritelistFetchedResultsController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        FavoriteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritelistFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
        
        let list = favoritelistFetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = list.title
        cell.detailTextLabel?.text = list.subtitle
        
        var images = ["beefSteak", "eggTart", "fryRice", "pasta"];
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    //MARK: NSFetchedResult
    private var favoritelistFetchedResultsController: NSFetchedResultsController<DishList>!
    
    //MARK: IBoutlet
    @IBOutlet private weak var FavoriteTableView: UITableView!
}
