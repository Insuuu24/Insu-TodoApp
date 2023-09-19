//
//  TodoData+CoreDataProperties.swift
//  
//
//  Created by Insu on 2023/09/19.
//
//

import Foundation
import CoreData


extension TodoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoData> {
        return NSFetchRequest<TodoData>(entityName: "TodoData")
    }

    @NSManaged public var content: String
    @NSManaged public var category: String
    @NSManaged public var date: Date

}
