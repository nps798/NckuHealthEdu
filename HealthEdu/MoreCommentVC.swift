//
//  MoreCommentVC.swift
//  HealthEdu
//
//  Created by Mac on 2016/9/25.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit
import Foundation

class MoreCommentVC: UIViewController {

    // MARK: 基本func 區
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openMailapp(sender: AnyObject) {
        
        let url = NSURL(string: "mailto:nps798@gmail.com")
        UIApplication.sharedApplication().openURL(url!)
        
        
    }
    

}
