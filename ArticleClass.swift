//
//  ArticleClass.swift
//  Define Class of a article
//
//  HealthEdu
//
//  Created by Mac on 2016/9/11.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//  

import Foundation
import UIKit

class article {
    
    
    // MARK:- Variable Declaration
    var id: String?
    
    var title: String?
    
    var photo: String?
    
    // for future, photoUIImage will contain image directly download from JSON server
    var photoUIImage: UIImage?
    
    var author: String?
    
    var body: String?
    
    var time: String?
    
    var division: String?
    
    var imageIsDefault: Bool?
    
    // MARK:- init() place
    
    /**
     init() 定義 article class 的基本元素
     */
    init (id: String?, title: String?, photoUIImage: UIImage?, photo: String?, author : String?, body : String?, time: String?, division: String?, imageIsDefault: Bool?){
        
        self.id = id
        self.title = title
        self.photo = photo
        self.photoUIImage = photoUIImage
        self.author = author
        self.body = body
        self.time = time
        self.division = division
        self.imageIsDefault = imageIsDefault
        
    }
    
}
