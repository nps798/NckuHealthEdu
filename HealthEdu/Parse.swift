//
//  Parse.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/9/30.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import Foundation

// Custom Error
enum ParseError: ErrorType {
    case CanNotParseJSONfile
}

// Parse Main Class
class Parse{
    
    static func fromJSONfile(filename: String?) throws -> NSArray {
        
        var jsonArray = NSArray()
        
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                if let result = Parse.parseJSONdata(jsonData){
                    
                    // put the result into jsonArray
                    jsonArray = result

                }else{
                    
                    throw ParseError.CanNotParseJSONfile
                    
                }
                
            }else{
                
                throw ParseError.CanNotParseJSONfile
                
            }
            
        }else{
            throw ParseError.CanNotParseJSONfile
        }
 
        return jsonArray
        
    }
    
    
    
    static func parseJSONdata(jsonData: NSData?) -> NSArray? {
        
        do {
            let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            // 暫時先把東西轉換成 array 以後應該是要用 Dictionary
            
            return jsonArray
            
        } catch let error as NSError {
            
            // TODO: 未來這裡要加入 伺服器錯誤 這種警語
            // 若 php 有錯誤使得 json 沒有正確顯示就會這樣！
            print("error processing json data: \(error.localizedDescription)")
            
            
            
        }
        
        return nil
        
    }
    
    /**
     used to parse dictionary json data
     
     - returns: jsonArray (the single article data)
     
     */
    static func parseJSONdataDict(jsonData: NSData?) -> NSDictionary? {
        
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            // 暫時先把東西轉換成 array 以後應該是要用 Dictionary
            
            return jsonDict
            
        } catch let error as NSError {
            
            // TODO: 未來這裡要加入 伺服器錯誤 這種警語
            // 若 php 有錯誤使得 json 沒有正確顯示就會這樣！
            print("error processing json data: \(error.localizedDescription)")
            
            
            
        }
        
        return nil
        
    }
    
}