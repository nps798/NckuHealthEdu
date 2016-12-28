//
//  SearchResultVC.swift
//  ViewController for showing search result
//
//  HealthEdu
//
//  Created by Mac on 2016/9/18.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
// 

import UIKit

class SearchResultVC: UITableViewController {
    
    
    // MARK:- Variable Declaration
    
    // the class of "article" is defined in file ArticleClass.swift
    var articleArray: [article] = []
    
    // contain the searchText
    var searchText: String?
    
    // activity indicator for loading search result from server
    var activityIndicator = UIActivityIndicatorView()

    // refreshControll for pull to refresh
    var refreshController: UIRefreshControl!
    
    // MARK:- Basic Func
    override func viewWillAppear(animated: Bool) {
        // check if user is connected to interent
        // show alert if not
        Reachability.checkInternetAndShowAlert(self)
        
        // custom extension of UITableView to deselect selected row
        self.tableView.deselectSelectedRow(animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "「\(searchText!.trunc(10))」"
                
        // build activityIndicator as WhiteLarge(change to blue later)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        // change activityIndicator color to blue (default iOS blue)
        self.activityIndicator.color = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        // init activityIndicator Animating
        self.activityIndicator.startAnimating()
        
        
        // not to display UITableView separator style
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        // remove separate line for empty cell
        self.tableView.tableFooterView = UIView()
        
        // set activityIndicator as StarTableViewIDB's backgrousView
        self.tableView.backgroundView = self.activityIndicator
        
        // define refreshControl
        self.refreshController = UIRefreshControl()
        
        // set refreshControl color
        self.refreshController.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.7)
        
        // addTarget when pull, which func to exe
        self.refreshController.addTarget(self, action: #selector(SearchResultVC.download), forControlEvents: UIControlEvents.ValueChanged)
        
        // start the whole search
        self.download()
        
    }
    
    
    func download(){
        // searchBar.text is the text user type in
        ListArticle.bySearchText(searchText!, completionHandler: {
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
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    
                    if self.articleArray.count == 0 {
                        
                        // no need to do below line in dispathc main
                        // because table reloadData() method is already in dispatch main
                        self.tableView.showNoRowInfo("找不到您所搜尋的項目。")
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                    }else{
                    
                        // reload tableView in animating style
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                    }
                    
                    
                    self.refreshController.endRefreshing()
                    
                    
                    if(!self.refreshController.isDescendantOfView(self.tableView)){
                        self.tableView.addSubview(self.refreshController)
                    }
                    
                    
                }
                
                
            }
                
           
            
            
            
        })
        
        


    }
    
    
    
    // MARK:- Func for table view
    
    
    /**
     Define How many section in this table view
     - return: Int for number of section
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.articleArray.count > 0 {
            
            return 1
            
        }else if self.articleArray.count == 0 {
            
            return 0
            
        }
        
        
        return 0
    }
    
    
    
    
    
    /**
        Define how many rows are there in each section
        since we have only one section in this table (offline data for now)
        there is no need to combine the variable "section" in this func
     
        - return: Int Simply return articleArray.count
     
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleArray.count
    }
    
    
    /**
        Define what to show in each row
     
        - return: UITableViewCell (photo, title, author, body)
     
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        // Define each structure as SearchResultCell
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell", forIndexPath: indexPath) as! SearchResultCell
        
        // set each row's image the DefaultPhotoForArticle
        // prevent repeat image because of dequeueReusableCellWithIdentifire()
        cell.searchResultCellPhoto.image = nil
        
        // get article detail according to variable "indexPath.row"
        let articleItem = articleArray[indexPath.row]
        print(articleItem.photoUIImage)
        if articleItem.photoUIImage == nil {
            print("do download image")
            // prove that photoUIImage has not been downloaded t
            cell.searchResultCellPhoto.imageFromServerURL(cell.searchResultCellPhoto, urlString: articleItem.photo!, completionHandler: {
                (imageFromNet) in
                
                // here insert image From Net to topicArray.topicPhotoUIImage
                self.articleArray[indexPath.row].photoUIImage = imageFromNet
                
            })
            
        }else{
            
            cell.searchResultCellPhoto.image = self.articleArray[indexPath.row].photoUIImage
            
        }
        
        
        
        cell.searchResultCellTitle.text = articleItem.title!.noHTMLtag
        
        cell.searchResultCellAuthor.text = articleItem.author
        
        cell.searchResultCellBody.text = articleItem.body!.noHTMLtag
    
    
        
        return cell
    }
    

    
    // MARK:- For change view to ArticleViewController (show each article in detail)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Define destination
        let articleDetail = segue.destinationViewController as! ArticleViewController
        
        // get the indexPath of Selected table row
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            // get article detail according to variable selected "indexPath.row"
            let articleSelected = articleArray[indexPath.row]
            
            // Put article content to variable at ArticleViewController
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
                articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
            }
            articleDetail.currentTimeString = articleSelected.time
            
            
            
        }
    }

}
