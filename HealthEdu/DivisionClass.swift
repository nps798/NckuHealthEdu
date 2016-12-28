//
//  DivisionClass.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/10/3.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//


import Foundation
import UIKit

class division {
    
    
    // MARK:- Variable Declaration
    var id: String?
    var division: String?
    var domain_id: String?
    var description: String?

    
    // MARK:- init() place
    
    /**
     init() 定義 article class 的基本元素
     */

    
    init(id: String?, division: String?, domain_id: String? , description: String?)
    {
        self.id = id
        self.division = division
        self.domain_id = domain_id
        self.description = description
    
    }

}
