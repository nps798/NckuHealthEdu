//
//  SearchResultCell.swift
//  This file is for table cell of each search result
//
//  HealthEdu
//
//  Created by Mac on 2016/9/18.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    // MARK:- Variable Declaration
    @IBOutlet weak var searchResultCellPhoto: UIImageView!
    
    @IBOutlet weak var searchResultCellTitle: UILabel!
    
    @IBOutlet weak var searchResultCellAuthor: UILabel!
    
    @IBOutlet weak var searchResultCellBody: UILabel!
    
    
    // MARK:- fundemental func for table view cell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
