//
//  MakeRecipeViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/3/4.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import CoreData
import UIKit

class MakeRecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makelistFetchedResultsController = DishService.shared.makeCategories()
        makelistFetchedResultsController?.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makelistFetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath)
        if let add = makelistFetchedResultsController?.object(at: indexPath){
            cell.textLabel!.text = add.name
            cell.detailTextLabel!.text = add.describe
        }

        return cell
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        MakeRecipeView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    //MARK: Show Segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If in edit mode, go to create detail screen
        if tableView.isEditing {
            performSegue(withIdentifier: "CreateDetailSegue", sender: self)
        }
        else {
            // Otherwise show the Make detail
            performSegue(withIdentifier: "MakeDetailSegue", sender: self)
        }
    }
    
    //MARK: Setup Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "CreateDetailSegue" {
            let createDetailViewController = segue.destination as! CreateDetailViewController
            let IndexPath = MakeRecipeView.indexPathForSelectedRow!
            createDetailViewController.addCreate = makelistFetchedResultsController?.object(at: IndexPath)
            MakeRecipeView.deselectRow(at: IndexPath, animated: true)
        }
        else if segue.identifier == "MakeDetailSegue" {
            let makeDetailViewController = segue.destination as! MakeDetailViewController
            let IndexPath = MakeRecipeView.indexPathForSelectedRow!
            makeDetailViewController.add = makelistFetchedResultsController?.object(at: IndexPath)
            MakeRecipeView.deselectRow(at: IndexPath, animated: true)
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: Properties (Private)
    private var makelistFetchedResultsController: NSFetchedResultsController<Add>!
    
    // MARK: IBAction (Unwind Segue)
    @IBAction private func createRecipeFinished(_ sender: UIStoryboardSegue) {
        
    }
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private var MakeRecipeView: UITableView!
    
}
