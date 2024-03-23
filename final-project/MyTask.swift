//
//  MyTask.swift
//  final-project
//
//  Created by J A on 2024-03-22.
//

import Foundation
import CoreData

@objc(MyTask)
class MyTask: NSManagedObject{
    @NSManaged var isCompleted: Bool
    @NSManaged var id: NSNumber!
    @NSManaged var dueDate : Date?
    @NSManaged var desc: String!
}
