import Foundation
import CoreData

@objc(MyTask)
class MyTask: NSManagedObject{
    @NSManaged var isCompleted: Bool
    @NSManaged var id: NSNumber!
    @NSManaged var dueDate : Date?
    @NSManaged var desc: String!
    @NSManaged var date : Date?

}
