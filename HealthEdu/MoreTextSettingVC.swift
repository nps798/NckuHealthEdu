//
//  MoreTextSettingVC.swift
//  HealthEdu
//
//  Created by Mac on 2016/9/25.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class MoreTextSettingVC: UIViewController{
    
    // MARK: - 變數宣告
    
    @IBOutlet var segmentFontSize: UISegmentedControl!

    var fontSizeUserDefaults : Int?
    
    // MARK: - 基本顯示func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(animated: Bool) {
        self.segmentFontSize.selectedSegmentIndex = self.getNowFontSizeForSegmentDefault()
    }

    
    func getNowFontSizeForSegmentDefault() -> Int{
        
        /* userDefault 初始化：儲存 預設 font size */
        let userDefault = NSUserDefaults.standardUserDefaults()
        // 初始化
        
        
        if let storedFontSize = userDefault.objectForKey("fontSizeUserDefaults") {
            
            return storedFontSize as! Int
            
        }else{
            
            return 1
            // 如果該 key 不存在的話，預設以 1 回傳
            
        }
        
    }
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func changeDefaultFontSize(sender: AnyObject) {
        
        /* 收集 segmentControl 的 fontSize */
        
        switch segmentFontSize.selectedSegmentIndex  {
            
        case 0:
            self.fontSizeUserDefaults = 0
            
        case 1:
            self.fontSizeUserDefaults = 1
            
        case 2:
            self.fontSizeUserDefaults = 2
            
        case 3:
            self.fontSizeUserDefaults = 3
            
        default:
            self.fontSizeUserDefaults = 1
        }
        
        
        MoreTextSettingVC.storeFontSizetoUserDefaults(self.fontSizeUserDefaults)
        // 將資料儲存進去
        

    }
    
    // MARK: 大家都可以來用的 change Font size user defaults
    
    static func storeFontSizetoUserDefaults(toStored: Int?){
        
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        // 初始化
        
        
        if toStored != nil{
            
            userDefault.setInteger(toStored! , forKey: "fontSizeUserDefaults")
            // 將 segment 的東西存入
            
        }else{
            
            userDefault.setInteger(1 , forKey: "fontSizeUserDefaults")
            
        }
        
        
        userDefault.synchronize()
        // userDefault 同步
        
        
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
