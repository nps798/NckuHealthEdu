//
//  BookmarkVCViewController.swift
//  ViewController for showing **History** and **Bookmark**
//
//  HealthEdu
//
//  Created by Mac on 2016/9/17.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit
import CoreData

class BookmarkVCViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    // MARK:- Variable Declaration
    
    // Segment Control for know user is in "History" or "Bookmark" page
    @IBOutlet weak var BookmarkSegControlIBO: UISegmentedControl!
    
    // refer to tool bar seg
    @IBOutlet var toolBarSeg: UIToolbar!
    
    // for storing articles
    var articleArrayHistory:[article] = [article]()
    var articleArrayBookmark:[article] = [article]()
    
    // table View link
    @IBOutlet weak var tableView: UITableView!
    
    
    // for core data (store articles)
    let core_data = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    // MARK:- Basic Func
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // avoid black shadow show on background when trasition
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
    }

    /**
     Magic here: each time when user "view" this viewController
    the following func viewWillAppear will be executed once.
    this is all for real-time reload tableView data
     
     - returns: nothing
     */
    override func viewWillAppear(animated: Bool) {


        // show history articles
        self.showHistory()
        
        // show bookmark articles
        self.showBookmark()
        
        self.tableView.reloadData()
        
        // custom extension of UITableView to deselect selected row
        self.tableView.deselectSelectedRow(animated: true)
        
        // remove separate line for empty cell
        self.tableView.tableFooterView = UIView()
        
    }
  
    /**
     Get History articles data from core data "HistoryEntities"
     and apply them to "articleArrayHistory"
     
     - returns: nothing
     */
    func showHistory(){
        
        
        articleArrayHistory = []
        
        // get core data
        let request = NSFetchRequest(entityName: "HistoryEntities")
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "autoIncrement", ascending: false)
        request.sortDescriptors = [idDescriptor]
        
        do {
            
            let results = try self.core_data.executeFetchRequest(request) as! [HistoryEntities]
            
            for result in results {
                
                articleArrayHistory.append(article(id: result.id! ,title: result.title!, photoUIImage: UIImage(data: result.photoUIImage!)! ,  photo: String(), author: result.author!, body: result.body!, time: result.time! , division: result.division!, imageIsDefault: result.imageIsDefault!.boolValue))
            }
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
        
    }
    
    
    
    /**
     Get Bookmark articles data from core data "BookmarkEntities",
     and apply them to "articleArrayBookmark"
     
     - returns: nothing
     */
    func showBookmark(){
        
        articleArrayBookmark = []
        
        
        // get core data
        let request = NSFetchRequest(entityName: "BookmarkEntities")
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "autoIncrement", ascending: false)
        request.sortDescriptors = [idDescriptor]
        
        do {
            
            let results = try self.core_data.executeFetchRequest(request) as! [BookmarkEntities]
            
            for result in results {
                
                articleArrayBookmark.append(article(id: result.id! ,title: result.title!, photoUIImage: UIImage(data: result.photoUIImage!)! ,  photo: String(), author: result.author!, body: result.body!, time: result.time! , division: result.division!, imageIsDefault: result.imageIsDefault!.boolValue))
            }
            
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        
    }
    
 
    /**
     Each time when segmentControl is pressed,
     the following func will be executed (reload the table view).
     
     - returns: nothing
     */
    @IBAction func BookmarkSegControlAction(sender: AnyObject) {
        
        self.tableView.reloadData()
        

    }
    
    
    
    // MARK:- TableView func
    
    /**
     Define How many section there are in table
     - returns: Int, in this case just return "1".
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        switch (BookmarkSegControlIBO.selectedSegmentIndex) {
        case 0:
            
            
            if self.articleArrayHistory.count == 0 {
                
                // no separate line
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                
                self.toolBarSeg.barTintColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                self.view.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                self.tableView.showNoRowInfo("目前您沒有紀錄文章。")
                
            }else{
                // single separate line
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                
                self.toolBarSeg.barTintColor = UIColor.whiteColor()
                // if there is article
                // set bg view to nil, or the bg view will no be set again
                self.tableView.backgroundView = nil
            }
            return 1
            
        case 1:
            
            
            if self.articleArrayBookmark.count == 0 {
                
                // no separate line
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                
                self.toolBarSeg.barTintColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                self.view.backgroundColor = UIColor.init(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                self.tableView.showNoRowInfo("目前您沒有收藏文章。")
                
            }else{
                
                // single separate line
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                
                self.toolBarSeg.barTintColor = UIColor.whiteColor()
                // if there is article
                // set bg view to nil, or the bg view will no be set again
                self.tableView.backgroundView = nil
            }
            
            return 1
        default:
            break
        }
        

        return 0
        
        
    }
    
    
    /**
     Define How many rows in that one section.
     - return: "articleArrayHistory.count" if segmentControl is History
     - return: "articleArrayBookmark.count" if segmentControl is Bookmark

     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // store row count
        var returnRowCount = 0
        
        switch (BookmarkSegControlIBO.selectedSegmentIndex) {
        case 0:
            // Segment Control is History
            returnRowCount = articleArrayHistory.count
            
        case 1:
            // Segment Control is Bookmark
            returnRowCount = articleArrayBookmark.count
            
        default:
            break
        }
        
        
        return returnRowCount
    }
    
    /**
     Define content of each cell.
     Same as the previous func, here we "switch" to know whether user is in History or Boookmark
     
     - returns: cell
     
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // define cell structure
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! myBookmarkCell
        
        switch (BookmarkSegControlIBO.selectedSegmentIndex) {
            
        case 0:
            // User is in History
            let articleItem = articleArrayHistory[indexPath.row]
            cell.BookmarkImageViewCellIBO.image = articleItem.photoUIImage
            cell.BookmarkTitleIBO.text = articleItem.title!.noHTMLtag
            cell.BookmarkAuthorIBO.text = articleItem.author
            cell.BookmarkBodyIBO.text = articleItem.body!.noHTMLtag
            break
            
        case 1:
            // User is in Bookmark
            let articleItem = articleArrayBookmark[indexPath.row]
            cell.BookmarkImageViewCellIBO.image = articleItem.photoUIImage
            cell.BookmarkTitleIBO.text = articleItem.title!.noHTMLtag
            cell.BookmarkAuthorIBO.text = articleItem.author
            cell.BookmarkBodyIBO.text = articleItem.body!.noHTMLtag
        default:
            break
        }
        return cell
    }
    
    
    /**
     Define that cell can edit---> for "向左滑出現刪除按鈕" function
     
     - returns: true
     
     */
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    /**
     Define what the app does after user click on CellEditingStle-Delete
     - returns: nothing
     */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            switch (BookmarkSegControlIBO.selectedSegmentIndex) {
                
            case 0:
                // delete that article from HistoryEntities
                self.deleteFromHistory(articleArrayHistory[indexPath.row].id!)
                break
                
            case 1:
                // delete that article from BookmarkEntities
                self.deleteFromBookmark(articleArrayBookmark[indexPath.row].id!)
                
            default:
                break
            }
            
            
        }
    }
    
    
    // MARK:- Delete From Core Data func
    
    /**
     Define what the app does after user click on CellEditingStle-Delete
     - parameter idToDelete: String, give the id to be deleted
     - returns: nothing
     */
    func deleteFromHistory(idToDelete: String)
    {
        
        let deleteRequest = NSFetchRequest(entityName: "HistoryEntities")
        deleteRequest.predicate = NSPredicate(format: "id == %@", idToDelete)
        
        do {
            
            let results = try self.core_data.executeFetchRequest(deleteRequest) as! [HistoryEntities]
            
            for result in results {
                
                self.core_data.deleteObject(result)
                
            }
            
            do {
                
                try self.core_data.save()
                
                self.showHistory()
                // 重整 table 資料來源
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    // 重整
                })
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
            }
            
        }catch{
            
            fatalError("Failed to fetch data: \(error)")
            
        }
        
        
    }
    
    
    /**
     Define what the app does after user click on CellEditingStle-Delete
     - parameter idToDelete: String, give the id to be deleted
     - returns: nothing
     */
    func deleteFromBookmark(idToDelete: String)
    {
        
        let deleteRequest = NSFetchRequest(entityName: "BookmarkEntities")
        deleteRequest.predicate = NSPredicate(format: "id == %@", idToDelete)
        
        do {
            
            let results = try self.core_data.executeFetchRequest(deleteRequest) as! [BookmarkEntities]
            
            for result in results {
                
                self.core_data.deleteObject(result)
                
            }
            
            do {
                
                try self.core_data.save()
                
                self.showBookmark()
                // 重整 table 資料來源
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    // 重整
                })
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
            }
            
        }catch{
            
            fatalError("Failed to fetch data: \(error)")
            
        }
        
        
    }
    
    
    // MARK:- View Change To ArticleViewController and Pass Data
    
    /**
     define destination view , and selectively pass data to destination
     - returns: nothing
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // define destination
        let articleDetail = segue.destinationViewController as! ArticleViewController
        
        // get click tableView indexPath
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            switch (BookmarkSegControlIBO.selectedSegmentIndex) {
                
                
            case 0:
                
                // user choose History
                let articleSelected = articleArrayHistory[indexPath.row]
                articleDetail.currentIdString = articleSelected.id
                articleDetail.currentTitleString = articleSelected.title
                articleDetail.currentBodyString = articleSelected.body
                articleDetail.currentAuthorString = articleSelected.author
                articleDetail.currentDivisionString = articleSelected.division
                if(articleSelected.photoUIImage == nil){
                    // indicate that this article does have image
                    // but its size is so large that it has not been completely downloaded yet.
                    let whiteUIImage = UIImage.imageWithColor(UIColor.whiteColor())
                    articleDetail.currentPhotoUIImage = whiteUIImage
                    
                }else if(articleSelected.imageIsDefault == true){
                    // indicate this article doesn't has image, so we use local DefaultPhotoForArticle as its image
                    // set imageIsDefault to true (for not displaying image and store true to core data)
                    articleDetail.imageIsDefault = true
                    articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
                }else{
                    // indicate this article has image, and image has been successfully downloaded
                    articleDetail.imageIsDefault = false
                    articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
                }
                articleDetail.currentTimeString = articleSelected.time
                break
                
            case 1:
                
                // user choose Bookmark
                let articleSelected = articleArrayBookmark[indexPath.row]
                articleDetail.currentIdString = articleSelected.id
                articleDetail.currentTitleString = articleSelected.title
                articleDetail.currentBodyString = articleSelected.body
                articleDetail.currentAuthorString = articleSelected.author
                articleDetail.currentDivisionString = articleSelected.division
                
                if(articleSelected.photoUIImage == nil){
                    // indicate that this article does have image
                    // but its size is so large that it has not been completely downloaded yet.
                    let whiteUIImage = UIImage.imageWithColor(UIColor.whiteColor())
                    articleDetail.currentPhotoUIImage = whiteUIImage
                    
                }else if(articleSelected.imageIsDefault == true){
                    // indicate this article doesn't has image, so we use local DefaultPhotoForArticle as its image
                    // set imageIsDefault to true (for not displaying image and store true to core data)
                    articleDetail.imageIsDefault = true
                    articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
                }else{
                    // indicate this article has image, and image has been successfully downloaded
                    articleDetail.imageIsDefault = false
                    articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
                }
                
                articleDetail.currentTimeString = articleSelected.time
                
            default:
                break
                
                
            }
            
 
            
        }
    }
    

    
}
