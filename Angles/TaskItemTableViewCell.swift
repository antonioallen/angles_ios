//
//  TaskItemTableViewCell.swift
//  Angles
//
//  Created by Antonio Allen on 6/8/17.
//  Copyright © 2017 Antonio Allen. All rights reserved.
//

import UIKit

class TaskItemTableViewCell: UITableViewCell {
    @IBOutlet weak var taskCounterLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskDueLabel: UILabel!
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
