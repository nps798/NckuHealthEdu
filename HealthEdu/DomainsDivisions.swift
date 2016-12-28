//
//  DomainsDivisions.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/10/3.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import Foundation


enum DomainsDivisionsError :ErrorType {
    case ParseJSONFail
}

class DomainsDivisions {
    
    /**
     get static domains and division from json file
     - returns: [domains?]
     */
    
    static func getHierarchy() throws -> [domain?] {
        
        // variable for use declaration
        var domains_divisions_hierarchy = [domain?]()
        
        var divisions_temp = [division?]()
    
        
        // get static json file data
        
        var DomainsArray = NSArray()
        
        var DivisionsArray = NSArray()
        
        do {
            
            // read Domains.json
            DomainsArray = try Parse.fromJSONfile("Domains")
            
            // read Divisions.json
            DivisionsArray = try Parse.fromJSONfile("Divisions") as! NSMutableArray
            
        } catch {

            throw DomainsDivisionsError.ParseJSONFail
            
        }
        

        
        
        // 以下把每一個 array 原本item 抓出來，轉換成 DivisionStruct的樣子
        for DomainItem in DomainsArray {
            
            divisions_temp = []
            
            for DivisionItem in DivisionsArray {
                
                if DivisionItem["domain"] as! String? == DomainItem["id"] as! String? {
                    
                    // 確認這是這個 domain 的東西 把他抓起來
                    divisions_temp.append(division(id: DivisionItem["id"] as! String?, division: DivisionItem["division"] as! String?, domain_id:  DivisionItem["domain"] as! String? , description: DivisionItem["description"] as! String?))

                    
                }
                
            }
            
            
            
            
            let newJsonItem = domain(id: DomainItem["id"] as! String?, domain: DomainItem["domain"]  as! String?, division_data: divisions_temp )
            
            domains_divisions_hierarchy.append(newJsonItem)
            
            
        }
        
        return domains_divisions_hierarchy
        
    }
    
    
    
    
    
}