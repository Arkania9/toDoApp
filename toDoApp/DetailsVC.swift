//
//  DetailsVC.swift
//  toDoApp
//
//  Created by Kamil Zajac on 29.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupImg: UIImageView!
    
    var currentGroup: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        configureTopView(group: currentGroup)
    }
    
    func configureTopView(group: Group) {
        self.currentGroup = group
        groupTitle.text = group.title
        groupDesc.text = group.desc
        groupImg.image = group.image as! UIImage?
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTask" {
            if let destination = segue.destination as? TaskVC {
                destination.currentGroup = currentGroup
            }
        }
    }
    
}

    
extension DetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as? DetailsCell {
            return cell
        }
        return DetailsCell()
    }
}

