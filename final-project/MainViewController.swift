//
//  MainViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-25.
//

import UIKit
import CoreData
var taskList = [MyTask]()

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var calCollectionView: UICollectionView!
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyTask")
            do{
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let task = result as! MyTask
                    taskList.append(task)
                }
            }catch{
                print("Fetching data has failed")
            }
        
        super.viewDidLoad()

        configureItems()
    }
    private func configureItems() {
        let titleLabel = UILabel()
        titleLabel.text = "March 2024"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        let button = UIBarButtonItem(barButtonSystemItem: .add, target:self ,action: #selector(addButtonTapped))
        button.tintColor = .black
        navigationItem.rightBarButtonItem = button
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        view.backgroundColor = .white
    }
    
    
    @objc func addButtonTapped() {
        performSegue(withIdentifier: "addPage", sender: nil)

        
    }

}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calCollectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalCollectionCell

        let cal = Calendar.current
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        let name = dateFormatter.string(from: date)
        cell.dayNameLabel.text = name

        cell.dateLabel.text = String(cal.component(.day, from: date))
        cell.dateLabel.textColor  = .white

        return cell
    }

}


////Task related code
///

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(taskList[0].dueDate)
    return taskList.count
      //     return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        tableView.layer.cornerRadius = 20
        task.container.layer.cornerRadius = 10
        
        
        let thisTask: MyTask!
        thisTask = taskList[indexPath.row]
        
        print("Hello from the controller ")
        
        task.taskDesc.text = thisTask.desc
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let dueDate = thisTask.dueDate {
            let formattedDate = dateFormatter.string(from: dueDate)
            task.taskTitle.text = formattedDate
        }
        if (thisTask.isCompleted == true){
            let checked = UIImage(named: "Checkbox")
            task.checkbox.setImage(checked, for: .normal)
            
            
          
        }
        return task
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "detailPage"){
            let indexPath = taskTableView.indexPathForSelectedRow!
            let selectedTask: MyTask!
            selectedTask = taskList[indexPath.row]
            
            
            if let dest = segue.destination as? InfoViewController {
                //dest.dueLabelText = "5:00PM"
               // dest.remainderLabelText = "2hrs:58mns"
               // dest.taskDescText  = selectedTask.desc
                dest.selectedTask = selectedTask
                }
            
            
        }


    }
   
}
