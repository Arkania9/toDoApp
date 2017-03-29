//
//  DetailsCell.swift
//  toDoApp
//
//  Created by Kamil Zajac on 29.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var blackView: UIView!

    func configureDetails(task: Task) {
        name.text = task.name
        mainImg.image = task.image as! UIImage?
    }
    
}
