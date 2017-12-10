//
//  DishListViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/2/23.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import CoreData
import UIKit
import Social

class DishListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    
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
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishlistFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
        let list = dishlistFetchedResultsController.object(at: indexPath)
        let descriptor = dishlistFetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = list.title
        cell.detailTextLabel?.text = descriptor.subtitle
        
        var images = ["beefSteak", "orangeChicken", "kongbaoChicken", "pasta", "porkSauceNoodle", "fryRice", "friedCabbage"];
        cell.imageView?.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = dishlistFetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dishTableView.reloadData()
    }
    
    //MARK: Show Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecipeDetailSegue", sender: self)
    }
    
    //MARK: Setup Segue
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
            //MARK: Alert
            let dishList = self.dishlistFetchedResultsController.object(at: indexPath)

            DishService.shared.favoriteDishList(dishList, isFavorite: true)
            
            let alertController = UIAlertController(title: "Add succeed", message: "Added in Favorite", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Nice", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            let shareActionSheet = UIAlertController(title: nil, message: "Share with", preferredStyle: .actionSheet)
            let twitterAction = UIAlertAction(title: "Twitter", style: .default, handler: { (action) -> Void in
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    let twittercomposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twittercomposer?.setInitialText("Share this")
                    
                    self.present(twittercomposer!, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Twitter Unavailable", message: "Make sure you have Twitter account and installed Twitter in your device", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            let facebookAction = UIAlertAction(title: "FaceBook", style: .default, handler: { (action) -> Void in
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    let facebookcomposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookcomposer?.setInitialText("Share this")
                    
                    self.present(facebookcomposer!, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "FaceBook Unavailable", message: "Make sure you have FaceBook account and installed FaceBook in your device", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            shareActionSheet.addAction(twitterAction)
            shareActionSheet.addAction(facebookAction)
            shareActionSheet.addAction(cancel)
            
            self.present(shareActionSheet, animated: true, completion: nil)
        }
        share.backgroundColor = .blue
        
        return [share, favorite]
    }
    
    //MARK: Allow edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ commitforRowAttableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: NSFetchedResult
    private var dishlistFetchedResultsController: NSFetchedResultsController<DishList>!
    
    //MARK: IBoutlet
    @IBOutlet private weak var dishTableView: UITableView!
    @IBOutlet weak var DishImageView: UIImageView!
}
