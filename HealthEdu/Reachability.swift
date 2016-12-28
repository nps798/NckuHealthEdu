//
//  Reachability.swift
//      check for internet connection
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/10/31.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import SystemConfiguration
import UIKit

class Reachability {
    
    static func checkInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func checkInternetAndShowAlert(uivc: UIViewController) {
        
        if(!Reachability.checkInternet()){
            
            // can not build Domains Division json hierarchy
            let alertMessage = UIAlertController(title: "無法連接伺服器", message: "請開啟手機 Wifi 或行動上網！", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
            
            
            alertMessage.addAction(okAction)
            
            // need add dispatch
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                uivc.presentViewController(alertMessage, animated: true, completion:nil)
            })
            
        }
        
        
        

        
    }
    
    
}