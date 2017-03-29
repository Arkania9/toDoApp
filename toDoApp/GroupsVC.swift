//
//  GroupsVC.swift
//  toDoApp
//
//  Created by Kamil Zajac on 28.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import CoreData

class GroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupObj = groups[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell {
            cell.configureGroup(group: groupObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func loadData() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            groups = try context.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch {
            print("Problem with load data \(error.localizedDescription)")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createNewGroup(with: image)
            })
        }
    }
    
    func createNewGroup(with image: UIImage) {
        let newGroup = Group(context: context)
        newGroup.image = image
        
        let inputAlert = UIAlertController(title: "New Group", message: "Enter a title and description.", preferredStyle: .alert)
        inputAlert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        inputAlert.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let titleTextField = inputAlert.textFields?.first
            let descriptionTextField = inputAlert.textFields?.last
            
            if titleTextField?.text != "" && descriptionTextField?.text != "" {
                newGroup.title = titleTextField?.text
                newGroup.desc = descriptionTextField?.text
                do {
                    try context.save()
                    self.loadData()
                } catch {
                    print("Could not save data \(error.localizedDescription)")
                }
            }
            
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func addGroup(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupDetails" {
            if let destination = segue.destination as? DetailsVC {
                destination.currentGroup = groups[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    

}






