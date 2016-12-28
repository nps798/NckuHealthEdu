//
//  ListSearchDefaultText.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/11/2.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import Foundation

class ListSearchDefaultText {
    
    
    /**
     this func is used to show default "hot" search text
     
     - returns: no return
     - completionHandler(Array<article> -> Void) return article array here
     */
    static func hotANDtrend(completionHandler: (Array<String>,Array<String>,String?) -> ()){
        
        // define Api Url
        let apiUrl: String = "https://ncku.medcode.in/json/listSearchDefaultText"

        let strToPost: String = ""
        
        var hotTextArray: [String] = []
        
        var trendTextArray: [String] = []
        
        
        
        // pass rowSelected to Connection Post
        Connection.postRequest(apiUrl, postString: strToPost,
            completionHandler: {
            (data, error) in
            
                if error != nil {
                    
                    switch error! {
                        
                    case "code-1009":
                        completionHandler([],[], "code-1009")
                    default:
                        completionHandler([],[], "other error")
                        
                    }
                    
                    
                    
                }else if let jsonArray = Parse.parseJSONdata(data) {
            
                
                    for a_text in jsonArray {
                        
                        if(a_text["category"] as? String == "hot"){
                            
                            hotTextArray.append(a_text["text"] as! String)
                            
                        }else if(a_text["category"] as? String == "trend"){
                            
                            trendTextArray.append(a_text["text"] as! String)
                            
                        }
                        
                        
                        
                    }
                
                    completionHandler(hotTextArray, trendTextArray, nil)
                
                }
            
            
            
        })
        
        
        
        
    }

    
}