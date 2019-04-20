//
//  DayPickerScheduleCell.swift
//  TestUIView
//
//  Created by Admin on 4/20/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class DayPickerScheduleCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
