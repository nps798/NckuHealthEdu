//
//  myBookmarkCell.swift
//  custom table view cell for bookmark
//  
//  HealthEdu
//
//  Created by Mac on 2016/9/18.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class myBookmarkCell: UITableViewCell {

    // MARK:- Variable Declaration
    @IBOutlet weak var BookmarkImageViewCellIBO: UIImageView!
    @IBOutlet weak var BookmarkTitleIBO: UILabel!
    @IBOutlet weak var BookmarkAuthorIBO: UILabel!
    @IBOutlet weak var BookmarkBodyIBO: UILabel!
    
    
    // Mark:- Func for table view Cell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
