//
//  listArticle.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/10/25.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import Foundation
import UIKit


class ListStar {
    
    /**
     this func is used by showing all star topics
     - returns: no returns
     - completionHandler(Array<topic>,error) -> Void return topic array here
        error: nil for no error, a String for error
     */
    static func byDefault(completionHandler: ([topic], String?) -> Void){
        
        
        // pass rowSelected to Connection Post
        Connection.postRequest("https://ncku.medcode.in/json/star", postString: "", completionHandler: {
            (data, error) in
            
            if error != nil {
                
                switch error! {
                    
                case "code-1009":
                    completionHandler([], "code-1009")
                default:
                    completionHandler([], "other error")

                }
                
                
                
            }else if let jsonArray = Parse.parseJSONdata(data) {
                
                var topicArray: [topic] = []
                
                for a_topic in jsonArray {
                    
                    // use UIImage for topicPhotoUIImage for now 
                    // it will be insert a UIImage later in StarMany.swift
                    let new_topic = topic(
                        topicId: a_topic["id"] as? String,
                        topicTitle: a_topic["title"] as? String,
                        topicPhoto: a_topic["photo"] as? String,
                        topicPhotoUIImage: UIImage(),
                        topicTime: a_topic["update_time"] as? String
                    )

                    topicArray.append(new_topic)

                    
                }
                
                completionHandler(topicArray, nil)
                
            }
            
                    
                    

        })
        
        

    }
    
    
    /*
    func OperateJson_And_AddToarticleArray(jsonData: NSData)
    {
        
        if let jsonArray = Parse.parseJSONdata(jsonData) {
            
            
            for a_article in jsonArray {
                
                ////////////////////////////////////////////////////////////
                /////////這裡應該要判斷是否該文章有image，若無，則採用預設/////////
                ////////////////////////////////////////////////////////////
                let photoUrl: String = "http://webpage.hosp.ncku.edu.tw/Portals/0/Issue14/6.jpg"
                
                
                // 取得圖片
                
                
                // 現在用假圖片，到時候要用類似下面這種方式 但是還要加上判斷
                // let photoUrl: String = "http://webpage.hosp.ncku.edu.tw"+(a_article["img_src"]!![0] as! String)
                
                
                Connection.GetImage(photoUrl, completionHandler: {
                    (Imagedata) in
                    
                    
                    self.image = UIImage(data: Imagedata)!
                    // 把 data 轉換成 UIImage
                    
                    let new_article = Article(title: a_article["title"] as! String, photo: self.image!, author: a_article["author"] as! String , body: a_article["content"] as! String)
                    
                    self.articleArray.append(new_article)
                    
                    
                    
                    // 以下為把資料貼到 view 上
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.tableView.reloadData()
                        
                        // 一定要在這個 dispatch_async() 裡面change UI
                        // Do not change UI from anything but the main thread, it is bound to make your application unstable, and crash unpredictably.
                    })
                    
                })
                
                
                
            }
            
            
        }
        
    }*/
}
