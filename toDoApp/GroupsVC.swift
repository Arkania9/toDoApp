//
//  GroupsVC.swift
//  toDoApp
//
//  Created by Kamil Zajac on 28.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import CoreData

class GroupsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!

    var controller: NSFetchedResultsController<Group>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        loadData()
    }
    
    func loadData() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = nil
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        self.controller = fetchController
        
        do {
            try fetchController.performFetch()
        } catch {
            print("Error with load data")
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
                let indexPath = self.tableView?.indexPath(for: sender as! GroupCell)
                destination.currentGroup = controller.object(at: indexPath!)
            }
        }
    }
}


// UITableView DataSource & Delegate
extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupObj = controller.object(at: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell {
            cell.configureGroup(group: groupObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
            context.delete(controller.object(at: indexPath))
            do {
                try context.save()
            } catch {
                print("Error with delete object")
            }
            break
        default:
            break
        }
    }
}

// NSFetchResultControllerDelegate
extension GroupsVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
}






