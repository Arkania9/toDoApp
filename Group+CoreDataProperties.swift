//
//  Group+CoreDataProperties.swift
//  toDoApp
//
//  Created by Kamil Zajac on 29.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import CoreData

extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group");
    }

    @NSManaged public var desc: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Group {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
