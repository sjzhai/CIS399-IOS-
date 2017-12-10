//
//  ModalViewController.swift
//  Assignment3
//
//  Created by Shengjie Zhai on 2017/1/28.
//  Copyright © 2017年 CIS 410. All rights reserved.
//

import UIKit

protocol sendingInformation {
    func modalViewControllerDidSelectDone(_ modalViewController: ModalViewController)
}

class ModalViewController: UIViewController {
    
    var delegate:sendingInformation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendData(_ sender: AnyObject) {
        delegate?.modalViewControllerDidSelectDone(self)
    }
}
