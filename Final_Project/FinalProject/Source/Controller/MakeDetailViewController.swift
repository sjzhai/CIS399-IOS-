//
//  MakeDetailViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 3/18/17.
//  Copyright © 2017 Shengjie Zhai. All rights reserved.
//

import CoreData
import UIKit

class MakeDetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDetaileView.rowHeight = UITableViewAutomaticDimension
        makeDetaileView.estimatedRowHeight = 30.0
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DishDetailCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cellone", for: indexPath) as! DishDetailCell
            cell.update(for: add.name!)
        }
        else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Celltwo", for: indexPath) as! DishDetailCell
            cell.update(for: add.describe!)

        }
        else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "titleCellone", for: indexPath) as! DishDetailCell
            cell.textone(for: "Ingredients")
        }
        else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cellthree", for: indexPath) as! DishDetailCell
            cell.update(for: add.ingredient!)
        }
        else if indexPath.row == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "titleCelltwo", for: indexPath) as! DishDetailCell
            cell.texttwo(for: "Steps")

        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "Cellfour", for: indexPath) as! DishDetailCell
            cell.update(for: add.step!)
        }
        
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        makeDetaileView.reloadData()
    }
    
    //MARK: Properties
    var add: Add! = nil
    
    //MARK: IBoutlet
    @IBOutlet private weak var makeDetaileView: UITableView!
}
