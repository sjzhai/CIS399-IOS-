//
//  DetailViewController.swift
//  Assignment3
//
//  Created by Shengjie Zhai on 2017/1/28.
//  Copyright © 2017年 CIS 410. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    static var presentedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentedLabel.text = "Detail View presented \(DetailViewController.incrementalCount()) times"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static func incrementalCount() ->Int{
        presentedCount += 1
        return presentedCount
    }
    @IBOutlet weak var presentedLabel: UILabel!
}
