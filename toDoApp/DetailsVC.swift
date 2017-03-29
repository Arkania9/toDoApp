//
//  DetailsVC.swift
//  toDoApp
//
//  Created by Kamil Zajac on 29.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupImg: UIImageView!
    
    var currentGroup: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTopView(group: currentGroup)
    }
    
    func configureTopView(group: Group) {
        self.currentGroup = group
        groupTitle.text = group.title
        groupDesc.text = group.desc
        groupImg.image = group.image as! UIImage?
    }

}
