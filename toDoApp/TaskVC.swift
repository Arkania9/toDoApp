//
//  TaskVC.swift
//  toDoApp
//
//  Created by Kamil Zajac on 29.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import CoreData

class TaskVC: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UILabel!

    var currentGroup: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }
    @IBAction func saveTask(_ sender: AnyObject) {
        let newTask = Task(context: context)
        guard let name = titleField.text, name != "",
        let desc = descField.text, desc != "",
        let location = locationField.text, location != "" else {
            return
        }
        newTask.name = name
        newTask.desc = desc
        newTask.location = location
        newTask.image = UIImage(named: "unselected")
        newTask.group = currentGroup
        do {
            try context.save()
        } catch {
            print("Error with save new task")
        }
        _ = navigationController?.popViewController(animated: true)
    }

}
