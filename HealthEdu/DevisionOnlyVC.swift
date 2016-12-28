//
//  DevisionOnlyVC.swift
//  HealthEdu
//
//  Created by Mac on 2016/9/11.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class DevisionOnlyVC: UITableViewController {
    
    
    
    @IBOutlet var DivisionOnlyVCTableView: UITableView!
    
    
    // MARK:- Variable Declaration
    var articleArray: [article] = []
    
    // contain division specific id selected from DevisionOnlyVC
    var divisionIdSelected: String?
    
    // contain division specifie title selected from DivisionOnlyVC
    var divisionTitleSelectedForNavigationShow: String?
    
    // contain already download articles' ids
    var excludeIdsArray: [String] = []
    
    // limit how many articles download show a time
    var limitCount: Int?
    
    // init activityindicator
    var activityIndicator = UIActivityIndicatorView()
    
    // loadMoreRowActivityIndicator
    var loadMoreRowAcitivityIndicator = UIActivityIndicatorView()
    
    // Bool for record status whether app is loadMoreData now
    var alreadyReachBottomAndLoad: Bool?
    
    // Bool for record status whether division articles have all been download
    var nothingToDownload: Bool?
    
    
    // initiate refreshControl
    var refreshController: UIRefreshControl!
    
    override func viewWillAppear(animated: Bool) {
        // check if user is connected to interent
        // show alert if not
        Reachability.checkInternetAndShowAlert(self)
        

        // custom extension of UITableView to deselect selected row
        self.tableView.deselectSelectedRow(animated: true)
    }
    
    // MARK:- Basic Func
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // set loadMoreRowAcitivityIndicator not animating and hidden
        self.loadMoreRowAcitivityIndicator.stopAnimating()
        self.loadMoreRowAcitivityIndicator.hidden = true

        // default set alreadyReachBottomAndLoad to false
        self.alreadyReachBottomAndLoad = false
        
        // default set nothingToDownload to false
        self.nothingToDownload = false
        
        // set navigation bar title
        self.title = divisionTitleSelectedForNavigationShow
        
        // build activityIndicator as WhiteLarge(change to blue later)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        // change activityIndicator color to blue (default iOS blue)
        self.activityIndicator.color = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        // init activityIndicator Animating
        self.activityIndicator.startAnimating()
        
        // not to display UITableView separator style
        self.DivisionOnlyVCTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // remove separate line for empty cell
        self.DivisionOnlyVCTableView.tableFooterView = UIView()
        
        // set activityIndicator as StarTableViewIDB's backgrousView
        self.DivisionOnlyVCTableView.backgroundView = self.activityIndicator
        
        // define refreshControl
        self.refreshController = UIRefreshControl()
        
        // set refreshControl color
        self.refreshController.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.7)
        
        // addTarget when pull, which func to exe (restart the division load -limit 15 articles)
        self.refreshController.addTarget(self, action: #selector(DevisionOnlyVC.download), forControlEvents: UIControlEvents.ValueChanged)


        // start the whole story
        self.download()
        
    }
    
    func download() {


        
        self.excludeIdsArray = []
        
        self.limitCount = 15
        
        ListArticle.byDivisionId(divisionIdSelected!, limitCount: limitCount!, excludeIds: self.excludeIdsArray, completionHandler: {
            (articleArray, error) in
            
            
            
            if error != nil {
                // there is error
                // change UI inside main queue
                
                switch error! {
                    
                case "code-1009":
                    
                    // define 3 seconde for dispathc after
                    let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    
                    dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                        
                        
                        print("請連上網路後，下拉重新整理。")
                        
                        // set articleArray to nothing
                        self.articleArray = []
                        
                        self.refreshController.endRefreshing()
                        
                        
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                        self.tableView.showNoRowInfo("請連上網路後，下拉重新整理。")
                        
                        if(!self.refreshController.isDescendantOfView(self.tableView)){
                            self.tableView.addSubview(self.refreshController)
                        }
                        
                        
                    }
                default:
                    
                    // define 3 seconde for dispathc after
                    let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    
                    dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                        
                        
                        print("網速過慢或連線問題。")
                        
                        
                        // set articleArray to nothing
                        self.articleArray = []
                        
                        self.refreshController.endRefreshing()
                        
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                        self.tableView.showNoRowInfo("網速過慢、或連線出現問題。")
                        
                        if(!self.refreshController.isDescendantOfView(self.tableView)){
                            self.tableView.addSubview(self.refreshController)
                        }
                        

                        
                        
                    }
                    
                }
                
                
                
                
            }else{

                // no network basic error
                
                
                // if there is less than 15 articles downloaded at first time,
                // there is no need to loadMoreRow... anymore
                // so, set nothingToDownload to true
                if articleArray.count < 15 {
                    self.nothingToDownload = true
                }
                
                
                for a_article in articleArray {
                    // extract all id from article array to excludeIdsArray
                    self.excludeIdsArray.append(a_article.id!)
                }
            

                // no matter how long it takes to download data from Server
                // the activityIndicator will animating from 3 seconds
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    
     
                    self.tableView.backgroundView = nil
                    
                    // stop activity indicator animating
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                    // refer self.topicArray to starTopicArray (Array from Server)
                    self.articleArray = articleArray

                    
                    // show the line separator again
                    self.DivisionOnlyVCTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    
                    
                    if self.articleArray.count == 0 {
                        
                        // no need to do below line in dispathc main
                        // because table reloadData() method is already in dispatch main
                        self.DivisionOnlyVCTableView.showNoRowInfo("「\(self.divisionTitleSelectedForNavigationShow!)」沒有衛教文章，敬請期待。")
                        
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                        
                    }else{
                        
                        // reload StarTableViewIBO in animating style
                        UIView.transitionWithView(self.DivisionOnlyVCTableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.DivisionOnlyVCTableView.reloadData()}, completion: nil)
                        
                    }
                    
                    self.refreshController.endRefreshing()
                    
                    if(!self.refreshController.isDescendantOfView(self.tableView)){
                        self.tableView.addSubview(self.refreshController)
                    }
                    
                    // reset nothingToDonwload
                    self.nothingToDownload = false
                    
                }
                
                
                
                
            }

            
            
        })

        
    }



    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.articleArray.count > 0 {
            
            return 1
            
        }else if self.articleArray.count == 0 {

            return 0
            
        }
        
        
        return 0
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! myArticleCell
        
        // set each row's image the DefaultPhotoForArticle
        // prevent repeat image because of dequeueReusableCellWithIdentifire()
        cell.myPhoto.image = nil
        
        
        let articleItem = articleArray[indexPath.row]
        
        
        if articleItem.photoUIImage == nil {
            // prove that photoUIImage has not been downloaded t
            cell.myPhoto.imageFromServerURL(cell.myPhoto, urlString: articleItem.photo!, completionHandler: {
                    (imageFromNet) in
                
                // TODO: 以下這行似乎可以防止 out of index articleArray 的情況
                // 有時候圖片下載比較慢，但是使用者又上拉重新整理 導致 Array 變成新的 
                // 等圖片下載完成，Array 的某個元素卻是空的，就會 out of index....
                // here insert image From Net to topicArray.topicPhotoUIImage
                if let targetUIImage: article = self.articleArray[indexPath.row] {
                        targetUIImage.photoUIImage = imageFromNet
                }else{
                    
                    print("image net download finish but no photoUIImage to put in")
                    
                }

            
            })

        }else{
            
            cell.myPhoto.image = self.articleArray[indexPath.row].photoUIImage
            
        }

        cell.title.text = articleItem.title!.noHTMLtag
        cell.author.text = articleItem.author
        cell.body.text = articleItem.body!.noHTMLtag
        
        return cell
    }
    
    /**
     Load More Row When Scroll to Bottom
     - returns: no
     */
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let lastElement = articleArray.count - 1
        
        if indexPath.row == lastElement && alreadyReachBottomAndLoad == false && self.nothingToDownload == false {
            
            // set true, prevent repeat reach bottom
            self.alreadyReachBottomAndLoad = true
            print("bottom")
            
            // dispatch show loadMoreRowAcitivityIndicator
            dispatch_async(dispatch_get_main_queue(), {
                
                // build loadMoreRowAcitivityIndicator as WhiteLarge(change to blue later)
                self.loadMoreRowAcitivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                
                // change loadMoreRowAcitivityIndicator color to blue (default iOS blue)
                self.loadMoreRowAcitivityIndicator.color = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                
                // set loadMoreRowAcitivityIndicator startAnimating and not hidden
                self.loadMoreRowAcitivityIndicator.startAnimating()
                self.loadMoreRowAcitivityIndicator.hidden = false
                
                // programmatically add loadMoreRowAcitivityIndicator to tableFooterView
                self.tableView.tableFooterView = self.loadMoreRowAcitivityIndicator
                
            })
            
            
            ListArticle.byDivisionId(divisionIdSelected!, limitCount: limitCount!, excludeIds: self.excludeIdsArray, completionHandler: {
                (articleArray, error) in
                
                
                if error != nil {
                    
                    switch error! {
                        
                    case "code-1009":
                        
                        // define 3 seconde for dispathc after
                        let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                        
                        dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                            
                            
                            print("請連上網路後，再下滑重新整理。")
                            
                            // set loadMoreRowAcitivityIndicator startAnimating and not hidden
                            self.loadMoreRowAcitivityIndicator.stopAnimating()
                            self.loadMoreRowAcitivityIndicator.hidden = true
                            
                            self.tableView.tableFooterView = nil
                            
                            // can not build Domains Division json hierarchy
                            let alertMessage = UIAlertController(title: "無法下載文章", message: "網路連線中斷，請檢查 Wifi 或行動上網是否正常！", preferredStyle: .Alert)
                            
                            let okAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                            
                            
                            alertMessage.addAction(okAction)

                            self.presentViewController(alertMessage, animated: true, completion:nil)

                            
                        }
                    default:
                        
                        // define 3 seconde for dispathc after
                        let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                        
                        dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                            
                            
                            print("網速過慢或連線問題。")
                            
                            
                            
                            // set loadMoreRowAcitivityIndicator startAnimating and not hidden
                            self.loadMoreRowAcitivityIndicator.stopAnimating()
                            self.loadMoreRowAcitivityIndicator.hidden = true
                            
                            self.tableView.tableFooterView = nil
                            
                            // can not build Domains Division json hierarchy
                            let alertMessage = UIAlertController(title: "無法下載文章", message: "網速過慢或連線問題，請檢查 Wifi 或行動上網是否正常！", preferredStyle: .Alert)
                            
                            let okAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                            
                            
                            alertMessage.addAction(okAction)
                            

                            self.presentViewController(alertMessage, animated: true, completion:nil)

                            
                            
                            
                        }
                        
                    }
                    
                    
                }else{
                    
                    
                    if articleArray.count == 0 {
                        print("there is nothing to download")
                        self.nothingToDownload = true
                    }
                    
                    for a_article in articleArray {
                        // extract all id from article array to excludeIdsArray
                        self.excludeIdsArray.append(a_article.id!)
                    }
                    
                    

                    
                    
                    // no matter how long it takes to download data from Server
                    // the activityIndicator will animating from 3 seconds
                    let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    
                    dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                        
                        // refer self.topicArray to starTopicArray (Array from Server)
                        self.articleArray += articleArray
                        
                        // set loadMoreRowAcitivityIndicator startAnimating and not hidden
                        self.loadMoreRowAcitivityIndicator.stopAnimating()
                        self.loadMoreRowAcitivityIndicator.hidden = true
                        
                        if self.nothingToDownload == true {
                            self.tableView.tableFooterView = nil
                        }
                        
                        
                        // reload StarTableViewIBO in animating style
                        UIView.transitionWithView(self.DivisionOnlyVCTableView, duration: 1.0, options: .TransitionNone, animations: {self.DivisionOnlyVCTableView.reloadData()}, completion: nil)
                        
                        
                    }
                    

                
                }
                
                

                
                // set to false, for trigger reach bottom next time
                self.alreadyReachBottomAndLoad = false
                
                

                
                
                
            })

        
            
        }
    }
    
    
    
    
    
    
    
    // MARK:- prepareForSegue 的 func

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let articleDetail = segue.destinationViewController as! ArticleViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let articleSelected = self.articleArray[indexPath.row]
            
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
                
            }else if((articleSelected.photoUIImage?.isEqual(UIImage(named: "DefaultPhotoForArticle"))) == true){
                // indicate this article doesn't has image, so we use local DefaultPhotoForArticle as its image
                // set imageIsDefault to true (for not displaying image and store true to core data)
                articleDetail.imageIsDefault = true
                articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
            }else{
                // indicate this article has image, and image has been successfully downloaded
                articleDetail.imageIsDefault = false
                print("false")
                articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
            }

            
            articleDetail.currentTimeString = articleSelected.time

            
        }
    }
    
 
    
    

  

}
