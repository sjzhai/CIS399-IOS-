//
//  DishListViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/2/23.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import CoreData
import UIKit

class DishListViewController : UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dishlistFetchedResultsController = DishService.shared.dishCategories()
        dishlistFetchedResultsController.delegate = self
        
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
    // MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dishTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishlistFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
        
        let list = dishlistFetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = list.title
        cell.detailTextLabel?.text = list.subtitle
        
        var images = ["beefSteak", "eggTart", "fryRice", "pasta"];
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecipeDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetailSegue" {
            let recipeDetailViewController = segue.destination as! RecipeDetailViewController
            let IndexPath = dishTableView.indexPathForSelectedRow!
            recipeDetailViewController.dishlist = dishlistFetchedResultsController.object(at: IndexPath)
            dishTableView.deselectRow(at: IndexPath, animated: true)
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: Swap buttons
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            
            
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share tapped")
        }
        share.backgroundColor = .blue
        
        return [share, favorite]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: NSFetchedResult
    private var dishlistFetchedResultsController: NSFetchedResultsController<DishList>!
    
    //MARK: IBoutlet
    @IBOutlet private weak var dishTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
}
