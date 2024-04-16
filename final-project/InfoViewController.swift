//
//  InfoViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-26.
//

import UIKit
import CoreData
protocol InfoViewControllerDelegate: AnyObject {
    func infoViewControllerDidDismiss(_ infoViewController: InfoViewController)
}
class InfoViewController: UIViewController, EditViewControllerDelegate {
    func editViewControllerDidDismiss(_ editViewController: EditViewController) {
        
        
    }
    weak var delegate: InfoViewControllerDelegate?

    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var remainderLabel: UILabel!
    @IBOutlet weak var taskDesc: UILabel!
    var dueLabelText = ""
    var taskDescText = ""
    var remainderLabelText = ""
    @IBOutlet weak var detailContainer: UIView!
    var selectedTask: MyTask!
    
    func editViewController(_ editViewController: EditViewController, didUpdateTask task: MyTask) {
        updateLabels(task: task)
        
    }

    @IBOutlet weak var detailWrapper: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels(task: selectedTask)
      
        detailContainer.layer.cornerRadius = 20
        detailWrapper.layer.cornerRadius = 20
    }
    
    func updateLabels(task: MyTask){
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let dueDate = selectedTask.dueDate {
                    let formattedDate = dateFormatter.string(from: dueDate)
                    dueLabel.text = "Due: \(formattedDate)"
                    
                    
                    if (selectedTask.isCompleted == false){
                        
                        let currentTime = Date()
                        let timeDifference = dueDate.timeIntervalSince(currentTime)
                        
                        let days = Int(timeDifference) / (3600 * 24)
                        let hours = (Int(timeDifference) % (3600 * 24)) / 3600
                        let minutes = (Int(timeDifference) % 3600) / 60
                        
                        if (days <= 0 &&  minutes <= 0){
                            remainderLabel.textColor = UIColor.systemRed
                            remainderLabel.text = "This Task is Overdue"
                        }
                        else{
                            var remainderLabelText = ""
                            if days > 0 {
                                remainderLabelText += "\(days) days "
                            }
                            remainderLabelText += "\(hours) hrs \(minutes) mins"
                            remainderLabel.text = "Time Remainder: \(remainderLabelText)"
                        }
                        
                        
                    }else{
                        remainderLabel.textColor = UIColor.systemGreen
                        remainderLabel.text = "This Task is Completed"
                    }

                }
        
        taskDesc.text = selectedTask.desc ?? "No description available";
    }
    
    @IBAction func onDeletePressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedTask != nil){
            context.delete(selectedTask)
            if let index = taskList.firstIndex(where: { $0.id == selectedTask.id }) {
                taskList.remove(at: index)
            }
            do{
                try context.save()
            }catch{
                print("Error deleting the task")
            }
        }
        self.delegate?.infoViewControllerDidDismiss(self)
        dismiss(animated: true)
    }
    
    @IBAction func onCompletePressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedTask != nil){
            print(selectedTask)
            do{
                selectedTask.isCompleted = true
                try context.save()
                print(selectedTask)
            }catch{
                print("Error deleting the task")
            }
        }
        self.delegate?.infoViewControllerDidDismiss(self)
        dismiss(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if let dest = segue.destination as? EditViewController {
                dest.selectedTask = selectedTask
                dest.delegate = self
                }
            
            
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            if isBeingDismissed {
                self.delegate?.infoViewControllerDidDismiss(self)
            }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
