//
//  MakeRecipeViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/3/1.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import UIKit
import CoreData

protocol sendingInformation {
    func createDetailViewControllerDidSelectDone(_ createDetailViewController: CreateDetailViewController)
}

class CreateDetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate {
    
    var delegate:sendingInformation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendData(_ sender: AnyObject) {
        delegate?.createDetailViewControllerDidSelectDone(self)
    }
    
    //MARK: Properties
    private var name: String?
    private var describe: String?
    private var ingredient: String?
    private var step: String?
    
    //MARK: IBOutlete
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var describeTextField: UITextField!
    @IBOutlet private var ingredientTextField: UITextField!
    @IBOutlet private var stepTextField: UITextField!
}
