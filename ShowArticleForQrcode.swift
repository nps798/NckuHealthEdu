//
//  ShowArticleForQrcode
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/11/9.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import Foundation
import UIKit


class ShowArticleForQrcode {
    
    /**
     this func is used by AppDelegate.swift to get the specific article info
     
     - returns: no resturn
     - completionHandler(Array<article> -> Void) return article array here
     */
    static func byArticleId(articleId: String, completionHandler: (Bool,article?) -> Void){
        
        
        // generate string to post
        let strToPost = "articleId=\(articleId)"
        
        // pass rowSelected to Connection Post
        Connection.postRequest("https://ncku.medcode.in/json/showArticleForQrcode", postString: strToPost, completionHandler: {
            (data, error) in
            
            
            if let jsonArray = Parse.parseJSONdataDict(data) {

                if jsonArray["error"] != nil{
                    completionHandler(false, nil)
                }
                
                // insert all data to singleArticleData
                let singleArticleData = article(
                    id: jsonArray["id"] as? String,
                    title: jsonArray["title"] as? String,
                    photoUIImage: nil,
                    photo: nil,
                    author: jsonArray["author"] as? String,
                    body: jsonArray["content"] as? String,
                    time: jsonArray["update_time"] as? String,
                    division: jsonArray["division"] as? String,
                    imageIsDefault: false)
                
                // call completionHandler
                completionHandler(true ,singleArticleData)

                
            }
            
            
            
            
        })
        
        
        
    }
}
