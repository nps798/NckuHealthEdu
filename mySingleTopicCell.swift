//
//  mySingleTopicCell.swift
//  HealthEdu
//
//  Created by Mac on 2016/9/18.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class mySingleTopicCell: UITableViewCell {

    @IBOutlet weak var singleTopicCellBody: UILabel!

    @IBOutlet weak var singleTopicCellAuthor: UILabel!
    @IBOutlet weak var singleTopicCellTitle: UILabel!
    @IBOutlet weak var singleTopicCellPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
