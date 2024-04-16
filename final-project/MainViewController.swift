//
//  MainViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-25.
//

import UIKit
import CoreData
import Foundation
var taskList = [MyTask]()

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate , InfoViewControllerDelegate, EditViewControllerDelegate{
    func editViewController(_ editViewController: EditViewController, didUpdateTask task: MyTask) {
    }
    
    func editViewControllerDidDismiss(_ editViewController: EditViewController) {
        taskTableView.reloadData();
    }
    
    func infoViewControllerDidDismiss(_ infoViewController: InfoViewController) {
        taskTableView.reloadData();

    }
    

    @IBOutlet weak var calCollectionView: UICollectionView!
    @IBOutlet weak var taskTableView: UITableView!
    let startDate = Date()
    var selectedDate = Date()
    let cal = Calendar.current
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData(date: selectedDate)
        configureItems(date:startDate)
    }
    func fetchData(date:Date){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyTask")
        let queryStartDate = cal.startOfDay(for: selectedDate)
        let queryEndDate = cal.date(byAdding: .day, value: 1, to: queryStartDate)
        let datePredicate = NSPredicate(format: "(date >= %@) AND (date < %@)", queryStartDate as NSDate, queryEndDate! as NSDate)
        request.predicate = datePredicate
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            taskList = [MyTask]()
            for result in results {
                let task = result as! MyTask
                taskList.append(task)
            }
        }catch{
            print("Fetching data has failed")
        }
    }
    private func configureItems(date:Date) {
        let titleLabel = UILabel()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        let dayDate = dateFormatter.string(from: date)

        titleLabel.text = "\(dayDate)"
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calCollectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalCollectionCell
        let date = getDateForIndex(for:indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let name = dateFormatter.string(from: date)
        cell.dayNameLabel.text = name
        cell.dayNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.dateLabel.text = String(cal.component(.day, from: date))
        cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        cell.dateLabel.textColor  = .white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedDate = getDateForIndex(for: indexPath)
            fetchData(date: selectedDate)
            configureItems(date: selectedDate)
        
            taskTableView.reloadData()
    }
    func getDateForIndex(for indexPath: IndexPath) -> Date {
        let sectionStartDate = cal.date(byAdding: .day, value: indexPath.section * 7, to: startDate)!
        return cal.date(byAdding: .day, value: indexPath.item, to: sectionStartDate)!
    }

}


////Task related code

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        tableView.layer.cornerRadius = 20
        task.container.layer.cornerRadius = 10
        let thisTask: MyTask!
        thisTask = taskList[indexPath.row]
        task.taskDesc.text = thisTask.desc
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let dueDate = thisTask.dueDate {
            let formattedDate = dateFormatter.string(from: thisTask.date!)
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
        switch segue.identifier {
        case "detailPage":
            let indexPath = taskTableView.indexPathForSelectedRow!
            let selectedTask: MyTask!
            selectedTask = taskList[indexPath.row]
            if let dest = segue.destination as? InfoViewController {
                //dest.dueLabelText = "5:00PM"
               // dest.remainderLabelText = "2hrs:58mns"
               // dest.taskDescText  = selectedTask.desc
                dest.selectedTask = selectedTask
                dest.delegate = self;
                }
        case "addPage":
            if let d = segue.destination as? EditViewController{
                d.date = selectedDate
                d.delegate = self
            }
        default:
            return
        }


    }
   
}
