//
//  MainViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-25.
//

import UIKit

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var calCollectionView: UICollectionView!
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }
    private func configureItems() {
        let titleLabel = UILabel()
        titleLabel.text = "March 2024"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        let button = UIBarButtonItem(barButtonSystemItem: .add, target:self , action: nil)
        button.tintColor = .black
        navigationItem.rightBarButtonItem = button
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        view.backgroundColor = .white
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
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        tableView.layer.cornerRadius = 20
        
        task.taskDesc.text = "this is just a task placeholder"
        task.container.layer.cornerRadius = 10
        return task
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let dest = segue.destination as? InfoViewController{
            dest.dueLabelText = "5:00PM"
            dest.remainderLabelText = "2hrs:58mns"
            dest.taskDescText  = "this is just a task placeholder"
            }
    }

}
