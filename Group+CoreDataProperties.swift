//
//  Group+CoreDataProperties.swift
//  toDoApp
//
//  Created by Kamil Zajac on 28.03.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group");
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: NSObject?

}
