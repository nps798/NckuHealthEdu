//
//  TopicClass.swift
//  本文件定義 topic 這個class
//  HealthEdu
//
//  Created by Yu-Ju Lin, Hsieh-Ting Lin.
//  Copyright © 2016年 衛教成大. All rights reserved.


import Foundation
import UIKit

class topic {
    
    var topicId: String?
    var topicTitle: String?
    var topicPhoto: String?
    var topicPhotoUIImage: UIImage?
    var topicTime: String?
    
    
    init (topicId: String?, topicTitle: String?, topicPhoto: String?, topicPhotoUIImage: UIImage?, topicTime: String?){
        
        self.topicId = topicId
        self.topicTitle = topicTitle
        self.topicPhoto = topicPhoto
        self.topicPhotoUIImage = topicPhotoUIImage
        self.topicTime = topicTime
        
    }
    
}