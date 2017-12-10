//
//  CategoryListViewController.swift
//  Assignment4
//
//  Created by Shengjie Zhai on 2017/2/5.
//
//

import UIKit

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CatService.shared.catCategories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = CatService.shared.catCategories()[indexPath.row].title
        cell.detailTextLabel?.text = CatService.shared.catCategories()[indexPath.row].subtitle
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "senderSegue" {
            let catImagesViewController = segue.destination as! CatImagesViewController
            let indexPath = catTableView.indexPathForSelectedRow!.row
            catImagesViewController.selectedCatIndex = indexPath
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
}
