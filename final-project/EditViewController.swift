//
//  EditViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-25.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var taskDescField: UITextField!
    @IBOutlet weak var timelineContainer: UIView!
    @IBOutlet weak var dueDate: UIDatePicker!
    var selectedTask: MyTask!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedTask != nil){
            taskDescField.text = selectedTask.desc
            submitButton.setTitle("Edit Task!", for: .normal)

        }else{
            submitButton.setTitle("Create Task!", for: .normal)

        }


        
        wrapper.layer.cornerRadius = 10
        container.layer
            .cornerRadius = 10
        taskDescField.layer.cornerRadius = 10
        timelineContainer.layer.cornerRadius = 10
    }
    
    @IBAction func onCreatePressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedTask == nil){
            let entity = NSEntityDescription.entity(forEntityName: "MyTask", in: context)
            let newTask = MyTask(entity: entity!, insertInto: context)
            newTask.desc = taskDescField.text
            newTask.id = taskList.count as NSNumber
            newTask.dueDate = dueDate.date
            do{
                try context.save()
                taskList.append(newTask)
                print(newTask)
            }catch{
                print("Error saving the task")
            }
        }else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyTask")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let task = result as! MyTask
                    if (task == selectedTask){
                        task.desc = taskDescField.text
                        task.dueDate = dueDate.date
                        task.isCompleted = false
                        try context.save()
                    }
                }
            }catch{
                print("Fetching data has failed")
            }
        }
       
    }
    


    
    
}
