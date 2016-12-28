//
//  DomainClass.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/10/3.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//


import Foundation
import UIKit

class domain {
    
    
    // MARK:- Variable Declaration
    var id : String?
    
    var domain : String?
    
    var division_data : [division?]
    

    
    
    // MARK:- init() place
    
    /**
     init() 定義 domain class 的基本元素
     */
    init (id: String?, domain: String?, division_data : [division?]){
        
        self.id = id
        self.domain = domain
        self.division_data = division_data

        
    }
    
}
