//
//  GroupCell.swift
//  toDoApp
//
//  Created by Kamil Zajac on 28.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    func configureGroup(group: Group) {
        title.text = group.title
        desc.text = (group.desc)?.uppercased()
        mainImg.image = group.image as? UIImage
    }
    
}
