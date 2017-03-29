//
//  Task+CoreDataProperties.swift
//  toDoApp
//
//  Created by Kamil Zajac on 29.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var date: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var isChecked: Bool
    @NSManaged public var group: Group?

}
