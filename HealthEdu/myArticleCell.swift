//
//  myArticleCell.swift
//  custom table view cell for article list show
//
//  HealthEdu
//
//  Created by Mac on 2016/9/12.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class myArticleCell: UITableViewCell {
    
    // MARK:- Variable Declaration
    @IBOutlet weak var myPhoto: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var body: UILabel!
    
    // MARK:- Other func for myArticleCell
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
