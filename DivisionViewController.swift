//
//  DivisionViewController.swift
//  The first viewController in Class tab menu
//  HealthEdu
//
//  Created by Yu-Ju Lin, Hsieh-Ting Lin.
//  Copyright © 2016年 衛教成大. All rights reserved.
//

import UIKit

// MARK: ViewController Get Domains Divsions Hierarchy
class DivisionViewController: UIViewController{
    
    // MARK: Variable Declaration
    
    var hierarchy = [domain?]()
    
    @IBOutlet var tableView: UITableView!
    
    // initiate refreshControl
    var refreshControl: UIRefreshControl!
    
    override func viewWillAppear(animated: Bool) {
        
        // check if user is connected to interent
        // show alert if not
        Reachability.checkInternetAndShowAlert(self)
        
        // custom extension of UITableView to deselect selected row
        self.tableView.deselectSelectedRow(animated: true)

        // remove separate line for empty cell
        self.tableView.tableFooterView = UIView()
    }
    
    
    
    /**
     Define how many section in table view, need modified in beta version
     - returns: 1:Int
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            
            try hierarchy = DomainsDivisions.getHierarchy()
            
        } catch {
            
            // can not build Domains Division json hierarchy
            let alertMessage = UIAlertController(title: "APP檔案毀損", message: "請移除「衛教成大」，再重新下載、安裝！", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)

            
            alertMessage.addAction(okAction)
            
            // need add dispatch
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(alertMessage, animated: true, completion:nil)
            })

            
        }
        
        
        
        
    }
    
}


    // MARK: - UI Table View Data Source
extension DivisionViewController: UITableViewDataSource {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return hierarchy.count
    }
    
    
    /**
     Define the title for header in section
     - returns: string
     */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return hierarchy[section]!.domain
        
        
    }
    
    
    
    /**
        Define numberOfRowsInSection
        - returns: count of different array. Add more condition in future
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hierarchy[section]!.division_data.count
        
    }
    
    
    

    
    
    
    /**
        Define cell
        - returns: cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("division", forIndexPath: indexPath) as UITableViewCell
        

        let division_name = hierarchy[indexPath.section]!.division_data[indexPath.row]!.division
        cell.textLabel?.text = division_name
        
        
        return cell
    }
    
    
    
    
    

    
    
    // TODO: 以後要在 json 仔入那邊確認每個 division data 的格式！
    
    /**
        Pass the data to the DevisionOnlyVC
        - returns: string
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let devisionVC = segue.destinationViewController as! DevisionOnlyVC
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            
            // pass the division specific id to DevisionOnlyVC
            devisionVC.divisionIdSelected = hierarchy[indexPath.section]!.division_data[indexPath.row]!.id
            
            // pass the division name to DevisionOnlyVC for navigation show
            devisionVC.divisionTitleSelectedForNavigationShow = hierarchy[indexPath.section]!.division_data[indexPath.row]!.division
            
            
        }
    }
    
}
