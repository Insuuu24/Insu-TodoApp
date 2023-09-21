//
//  TodoData+CoreDataProperties.swift
//
//
//  Created by Insu on 2023/09/19.
//
//

import Foundation
import CoreData

public extension TodoData {

    @nonobjc class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged var content: String
    @NSManaged var category: String
    @NSManaged var date: Date
}
