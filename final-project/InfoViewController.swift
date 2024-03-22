//
//  InfoViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-26.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var remainderLabel: UILabel!
    @IBOutlet weak var taskDesc: UILabel!
    var dueLabelText = ""
    var taskDescText = ""
    var remainderLabelText = ""
    @IBOutlet weak var detailContainer: UIView!

    @IBOutlet weak var detailWrapper: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dueLabel.text = "Due: \(dueLabelText)"
        taskDesc.text =  "\(taskDescText)"
        remainderLabel.text =  "Time Remainder: \(remainderLabelText)"
        detailContainer.layer.cornerRadius = 20
        detailWrapper.layer.cornerRadius = 20
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
