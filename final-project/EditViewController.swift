//
//  EditViewController.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-25.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var taskDescField: UITextField!
    @IBOutlet weak var timelineContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        wrapper.layer.cornerRadius = 10
        container.layer
            .cornerRadius = 10
        taskDescField.layer.cornerRadius = 10
        timelineContainer.layer.cornerRadius = 10
    }
}
