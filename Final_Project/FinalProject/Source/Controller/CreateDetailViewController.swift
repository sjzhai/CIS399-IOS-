//
//  MakeRecipeViewController.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/3/1.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import UIKit
import CoreData
import Foundation

protocol createDetailViewDelegate: class {
    func createDetailViewController(_ viewController: CreateDetailViewController, didChange add: Add)
}

class CreateDetailViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: View Management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = name
        describeTextField.text = describe
        ingredientTextField.text = ingredient
        stepTextField.text = step
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let value = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        if textField == nameTextField {
            name = value
        }
        else if textField == describeTextField {
            describe = value
        }
        else if textField == ingredientTextField {
            ingredient = value
        }
        else if textField == stepTextField {
            step = value
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        
        return false
    }
    
    //MARK: IBAction
    @IBAction func Cancel(segue: AnyObject){ //cancel button action
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func Done(segue: AnyObject){ //done button action
        if let someName = name, let somedescribe = describe, let someingredient = ingredient, let somestep = step {
            if selectedRecipe == nil {
                do {
                    try DishService.shared.addCategory(withName: someName, describe: somedescribe, ingredient: someingredient, step: somestep)
                }
                catch let error {
                    fatalError("Failed to add recipe: \(error)")
                }
            }
        }
        performSegue(withIdentifier: "DoneUnwindSegue", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    weak var delegate: createDetailViewDelegate?
    
    // MARK: Properties
    var addCreate: Add!
    var selectedRecipe: Add? {
        didSet {
            if let someRecipe = selectedRecipe {
                name = someRecipe.name
                describe = someRecipe.describe
                ingredient = someRecipe.ingredient
                step = someRecipe.step
            }
        }
    }
    
    //MARK: Properties(private)
    private var name: String?
    private var describe: String?
    private var ingredient: String?
    private var step: String?
    
    //MARK: IBOutlete
    @IBOutlet private var createTableView: UITableView!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var describeTextField: UITextField!
    @IBOutlet private var ingredientTextField: UITextField!
    @IBOutlet private var stepTextField: UITextField!
}
