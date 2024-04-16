//
//  EditViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-25.
//

import UIKit
import CoreData
protocol EditViewControllerDelegate: AnyObject {
    func editViewControllerDidDismiss(_ editViewController: EditViewController)
    func editViewController(_ editViewController: EditViewController, didUpdateTask task: MyTask)

}

class EditViewController: UIViewController {
    weak var delegate: EditViewControllerDelegate?
    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var taskDescField: PaddedTextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    var date = Date();
    var selectedTask: MyTask!
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDate.minimumDate = date
        if (selectedTask != nil){
            taskDescField.text = selectedTask.desc
            dueDate.date = selectedTask.dueDate!
            submitButton.setTitle("Edit Task!", for: .normal)
            
        }else{
            submitButton.setTitle("Create Task!", for: .normal)
            
        }
        wrapper.layer.cornerRadius = 10
        container.layer
            .cornerRadius = 10
        taskDescField.layer.cornerRadius = 10

    }
    
    @IBAction func onCreatePressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedTask == nil){
            print("\(date)");
            let entity = NSEntityDescription.entity(forEntityName: "MyTask", in: context)
            let newTask = MyTask(entity: entity!, insertInto: context)
            newTask.desc = taskDescField.text
            newTask.id = taskList.count as NSNumber
            newTask.dueDate = dueDate.date
            newTask.date = date
            do{
                try context.save()
                taskList.append(newTask)
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
                        if let index = taskList.firstIndex(where: { $0.id == selectedTask.id }) {
                            taskList[index].desc = taskDescField.text
                            taskList[index].dueDate = dueDate.date
                        }
                        if let delegate = delegate {
                                    delegate.editViewController(self, didUpdateTask: task)
                                }
                        try context.save()
                    }
                }
            }catch{
                print("Fetching data has failed")
            }
        }
        self.delegate?.editViewControllerDidDismiss(self)
        dismiss(animated: true)
       
    }
    


    
    
}
class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
