//
//  DishDetailCell.swift
//  FinalProject
//
//  Created by Shengjie Zhai on 2017/2/27.
//  Copyright © 2017年 Shengjie Zhai. All rights reserved.
//

import UIKit


class DishDetailCell: UITableViewCell {
    func update(for text: String) {
        DishDetailLabel.text = text
        
    }
    
    func textone(for text: String) {
        DishDetailLabel.text = text
    }
    
    func texttwo(for text: String) {
        DishDetailLabel.text = text
    }
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private weak var DishDetailLabel: UILabel!
}
