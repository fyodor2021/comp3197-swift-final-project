//
//  TaskTableViewCell.swift
//  final-project
//
//  Created by Raneem Barakat on 2024-02-26.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var container: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



}
