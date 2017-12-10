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
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritelistFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let isFavorite = favoritelistFetchedResultsController.object(at: indexPath)
        
        if cell.textLabel?.isEnabled == isFavorite.isFavorite {
            cell.textLabel?.text = isFavorite.title
            cell.detailTextLabel?.text = isFavorite.subtitle
        }
        
        return cell
    }
    
    //MARK: Show Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FavoriteToRecipeDetailSegue", sender: self)
    }
    
    //MARK: Setup Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteToRecipeDetailSegue" {
            let recipeDetailViewController = segue.destination as! RecipeDetailViewController
            let IndexPath = FavoriteTableView.indexPathForSelectedRow!
            recipeDetailViewController.dishlist = favoritelistFetchedResultsController.object(at: IndexPath)
            FavoriteTableView.deselectRow(at: IndexPath, animated: true)
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: Swap buttons
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let dishList = self.favoritelistFetchedResultsController.object(at: indexPath)
            DishService.shared.favoriteDishList(dishList, isFavorite: false)
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    //MARK: Allow edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            //delete the cell
            FavoriteTableView.reloadData()
        }
    }
    
    //MARK: NSFetchedResult
    private var favoritelistFetchedResultsController: NSFetchedResultsController<DishList>!
    
    //MARK: IBoutlet
    @IBOutlet private weak var FavoriteTableView: UITableView!
}
