//
//  myTopicsCell.swift
//  本文件定義在topic顯示列中的prototype cell的一些形式
//  HealthEdu
//
//  Created by Yu-Ju Lin, Hsieh-Ting Lin.
//  Copyright © 2016年 衛教成大. All rights reserved.


import UIKit

class myTopicsCell: UITableViewCell {
    
    
    @IBOutlet weak var opacityhalf: UIImageView!
    @IBOutlet weak var topicTitleIBO: UILabel!
    @IBOutlet weak var topicPhotoIBO: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
