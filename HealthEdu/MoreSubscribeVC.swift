//
//  MoreSubscribeVC.swift
//  HealthEdu
//
//  Created by Mac on 2016/9/25.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class MoreSubscribeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func subscribe(sender: AnyObject) {
        
        // 返回上一頁 programmatically
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
