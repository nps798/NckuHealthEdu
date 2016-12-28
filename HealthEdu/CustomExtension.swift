//
//  CustomExtension.swift
//  HealthEdu
//
//  Created by Yu-Ju Lin on 2016/10/1.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    var noHTMLtag: String {
        return  self.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
    
    
}


extension UIImageView {
    public func imageFromServerURL(view: UIImageView, urlString: String, completionHandler: UIImage -> Void) {
        
            if(urlString == ""){
            
                // when there is no provided photo url
                let image = UIImage(named: "DefaultPhotoForArticle")
                
                
                // update UI
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    
  
                    // image view transition animate
                    UIImageView.transitionWithView(
                        
                        view,
                        
                        duration: 2.0,
                        
                        options: .TransitionCrossDissolve,
                        
                        animations: {
                            self.alpha = 0.3
                            self.image = image
                            self.alpha = 1.0
                        },
                        
                        completion: nil
                        
                    )
                    
                    
                    completionHandler(image!)
                    
                })

                
            }else{

                // photo url exist
                // execute download
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: { (data, response, error) -> Void in

                    if error != nil {
                        print(error)
                        return
                    }
                
                    // update UI
                    dispatch_async(dispatch_get_main_queue(), {
                        () -> Void in
                    
                        let image = UIImage(data: data!)

                        // image view transition animate
                        UIImageView.transitionWithView(
                            
                            view,
                            
                            duration: 2.0,
                            
                            options: .TransitionCrossDissolve,
                            
                            animations: {
                                self.alpha = 0.3
                                self.image = image
                                self.alpha = 1.0
                            },
                            
                            completion: nil
                            
                        )
                        
                        
                        completionHandler(image!)
                    
                    })

                }).resume()
            
            }
        }
}




extension UITableView {
    
    public func showNoRowInfo(infoText: String){
        // need to use this inside dispathc
        
        let bgView: UIView = UIView()
        bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        let noDataLabel: UILabel = UILabel()
        
        
        noDataLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        noDataLabel.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        noDataLabel.text = infoText
        noDataLabel.font = UIFont.systemFontOfSize(CGFloat(20))
        noDataLabel.textColor = UIColor.grayColor()
        noDataLabel.textAlignment = .Center
        self.separatorStyle = .None
        
        bgView.addSubview(noDataLabel)
        
        
        self.backgroundView = bgView

    }
    
    
}


extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


extension UITableView {
    
    public func deselectSelectedRow(animated animated: Bool)
    {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow
        {
            self.deselectRowAtIndexPath(indexPathForSelectedRow, animated: animated)
        }
    }
    
}