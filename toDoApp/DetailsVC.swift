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
    
    var controller: NSFetchedResultsController<Task>!
    var currentGroup: Group!
    var selectedRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configureTopView(group: currentGroup)
        loadData()
    }
    
    func configureTopView(group: Group) {
        self.currentGroup = group
        groupTitle.text = group.title
        groupDesc.text = group.desc
        groupImg.image = group.image as! UIImage?
    }

    func loadData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let predicate = NSPredicate(format: "group == %@", currentGroup ?? Group())
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        self.controller = fetchController
        do {
            try fetchController.performFetch()
        } catch {
            print("Error with fetching data")
        }
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
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskObj = controller.object(at: indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as? DetailsCell {
            cell.configureDetails(task: taskObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskObj = controller.object(at: indexPath)
        if taskObj.isChecked {
            taskObj.isChecked = false
            do {
                try context.save()
            } catch _ {}
        } else {
            taskObj.isChecked = true
            do {
                try context.save()
            } catch _ {}
        }
        selectedRow = indexPath as IndexPath
        tableView.reloadRows(at: [indexPath], with: .none)
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

extension DetailsVC: NSFetchedResultsControllerDelegate {
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

