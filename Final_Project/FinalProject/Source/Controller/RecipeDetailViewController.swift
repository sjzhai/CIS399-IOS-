//
//  RecipeDetailViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/2/23.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import CoreData
import UIKit

import AVKit
import UIKit
import AVFoundation

class RecipeDetailViewController : UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate{
    
    //MARK: Set up AVKit
    var selectedUrl = String()
    var selectedTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.rowHeight = UITableViewAutomaticDimension
        recipeTableView.estimatedRowHeight = 30.0
        
        recipedetailFetchedResultsController = DishService.shared.cookRecipe(for: dishlist)
        recipedetailFetchedResultsController.delegate = self
    }
    
    @IBAction private func playVideo(sender: AnyObject) {
        //add infos about video button, or video view something.
        let videourl: String? = dishlist.videoURL!
        let videoURL = URL(string: videourl!)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }

    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DishDetailCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCell", for: indexPath) as! DishDetailCell
        }
        else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCellone", for: indexPath) as! DishDetailCell
        }
        else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCelltwo", for: indexPath) as! DishDetailCell
        }
        else if indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCellthree", for: indexPath) as! DishDetailCell
        }
        else if indexPath.row == 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCellfour", for: indexPath) as! DishDetailCell
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailCellfive", for: indexPath) as! DishDetailCell
        }
        
        
        let list = recipedetailFetchedResultsController.object(at: indexPath)
        cell.update(for: list.recipe!)
        
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        recipeTableView.reloadData()
    }

    //MARK: Property
    var dishlist: DishList! = nil
    
    //MARK: NSFetchedResult
    private var recipedetailFetchedResultsController: NSFetchedResultsController<Detail>!
    
    //MARK: IBoutlet
    @IBOutlet private weak var recipeTableView: UITableView!
}
