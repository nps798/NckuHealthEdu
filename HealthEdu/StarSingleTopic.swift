//
//  StarSingleTopic.swift
//  After user click single topic, it will seque to this view controller.
//  HealthEdu
//
//  Created by Yu-Ju Lin, Hsieh-Ting Lin.
//  Copyright © 2016年 衛教成大. All rights reserved.

import UIKit

class StarSingleTopic: UIViewController {

    // topic photo
    @IBOutlet weak var TopicMainPhoto: UIImageView!
    
    // topic title
    @IBOutlet weak var TopicMainTitle: UILabel!

    // the whole table view
    @IBOutlet weak var ArticleInTopicTableView: UITableView!
    
    
    // contain topic's id pass from StarMany.swift
    var TopicMainIdString: String?
    
    // contain topic's Photo pass from StarMany.swift
    var TopicMainPhotoFromMany = UIImage()
    
    // TODO: 可以刪除這個了！
    var TopicMainPhotoString: String?
    
    // contian topic's Title pass from StarMany.swift
    var TopicMainTitleString: String?
    
    // init activityindicator
    var activityIndicator = UIActivityIndicatorView()
    
    // contain whole article belong to specific topic
    var articleArray: [article] = []
    
    // initiate refreshControl
    var refreshControl: UIRefreshControl!
    
    override func viewWillAppear(animated: Bool) {
        // check if user is connected to interent
        // show alert if not
        Reachability.checkInternetAndShowAlert(self)
        
        // custom extension of UITableView to deselect selected row
        self.ArticleInTopicTableView.deselectSelectedRow(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set UI - topic's photo
        self.TopicMainPhoto.image = TopicMainPhotoFromMany
        
        // set UI - topic's Title
        self.TopicMainTitle.text = TopicMainTitleString
        
              
        
        
        // build activityIndicator as WhiteLarge(change to blue later)
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        // change activityIndicator color to blue (default iOS blue)
        self.activityIndicator.color = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        // init activityIndicator Animating
        self.activityIndicator.startAnimating()
        
        
        // not to display UITableView separator style
        self.ArticleInTopicTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        // remove separate line for empty cell
        self.ArticleInTopicTableView.tableFooterView = UIView()
        
        // set activityIndicator as StarTableViewIDB's backgrousView
        self.ArticleInTopicTableView.backgroundView = self.activityIndicator
        
        
        // define refreshControl
        self.refreshControl = UIRefreshControl()
        
        // set refreshControl color
        self.refreshControl.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.7)
        
        // addTarget when pull, which func to exe
        self.refreshControl.addTarget(self, action: #selector(StarSingleTopic.download), forControlEvents: UIControlEvents.ValueChanged)
        
        
        
        // execute download, start!!!
        self.download()
        
        
    }
    
    func download()
    {
        
    
        ListArticle.byStarTopic(TopicMainIdString!, completionHandler: {
            (topicArticleArray, error) in
        
     
            
            if error != nil {
                // there is error
                // change UI inside main queue
                
                switch error! {
                    
                case "code-1009":
                    
                    // define 3 seconde for dispathc after
                    let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    
                    dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                        
 
                        print("請連上網路後，下拉重新整理。")
                        
                        self.articleArray = []
                        
                        self.refreshControl.endRefreshing()
                        
                        
                        UIView.transitionWithView(self.ArticleInTopicTableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.ArticleInTopicTableView.reloadData()}, completion: nil)
                        
                        self.ArticleInTopicTableView.showNoRowInfo("請連上網路後，下拉重新整理。")
                        
                        if(!self.refreshControl.isDescendantOfView(self.ArticleInTopicTableView)){
                            self.ArticleInTopicTableView.addSubview(self.refreshControl)
                        }
                        
                        
                    }
                default:
                    
                    // define 3 seconde for dispathc after
                    let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    
                    dispatch_after(threeSeconds, dispatch_get_main_queue()) {

                        print("網速過慢或連線問題。")
                        
                        // set topicArray to nothing
                        self.articleArray = []
                        
                        self.refreshControl.endRefreshing()
                        
                        UIView.transitionWithView(self.ArticleInTopicTableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.ArticleInTopicTableView.reloadData()}, completion: nil)
                        
                        self.ArticleInTopicTableView.showNoRowInfo("網速過慢、或連線出現問題。")
                        
                        if(!self.refreshControl.isDescendantOfView(self.ArticleInTopicTableView)){
                            self.ArticleInTopicTableView.addSubview(self.refreshControl)
                        }
                        
                        
                    }
                    
                }
                
                
                
                
            }else{
                
                // no matter how long it takes to download data from Server
                // the activityIndicator will animating from 3 seconds
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    
                    self.ArticleInTopicTableView.backgroundView = nil
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                    // refer self.topicArray to starTopicArray (Array from Server)
                    self.articleArray = topicArticleArray
                    
                    // show the line separator again
                    self.ArticleInTopicTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    
                     self.refreshControl.endRefreshing()
                    
                    if self.articleArray.count == 0 {
                        
                        // no need to do below line in dispathc main
                        // because table reloadData() method is already in dispatch main
                        self.ArticleInTopicTableView.showNoRowInfo("本主題沒有衛教文章。")
                        UIView.transitionWithView(self.ArticleInTopicTableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.ArticleInTopicTableView.reloadData()}, completion: nil)
                        
                    }else{
                        
                        UIView.transitionWithView(self.ArticleInTopicTableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.ArticleInTopicTableView.reloadData()}, completion: nil)
                        
                    }
                    
                    if(!self.refreshControl.isDescendantOfView(self.ArticleInTopicTableView)){
                        self.ArticleInTopicTableView.addSubview(self.refreshControl)
                    }
                    
                }

                
                
            }
        })
        

    }

}


    // MARK: - Table view data source

extension StarSingleTopic: UITableViewDataSource, UITableViewDelegate {
    
    
    
    /**
     Define how many section in table view
     - returns: 1:Int
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.articleArray.count > 0 {
            
            return 1
            
        }else{
            
            return 0
            
        }
    }
    
    
    
    /**
     
        Define numberOfRowsInSection
        - returns: count of topic_and_article_Array
     
     */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.articleArray.count
    }
    
    
    
    
    /**
        Define the cell.
        The cell Identifier in Storyboard is called articleCellinTopic
     
        - returns: cell
     */
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        // define the cell in file mySingleTopicCell.swift,and  the cell ID is called "articleCellinTopic" in Storyboard
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCellinTopic", forIndexPath: indexPath) as! mySingleTopicCell
        
        // set each row's image the DefaultPhotoForArticle
        // prevent repeat image because of dequeueReusableCellWithIdentifire()
        cell.singleTopicCellPhoto.image = nil
        
        // get the specific articleItem
        let articleItem = self.articleArray[indexPath.row]
        
        
        
        if articleItem.photoUIImage == nil {
            // prove that photoUIImage has not been downloaded t
            cell.singleTopicCellPhoto.imageFromServerURL(cell.singleTopicCellPhoto, urlString: articleItem.photo!, completionHandler: {
                (imageFromNet) in
                
                // here insert image From Net to topicArray.topicPhotoUIImage
                self.articleArray[indexPath.row].photoUIImage = imageFromNet
                
            })
            
        }else{
            cell.singleTopicCellPhoto.image = self.articleArray[indexPath.row].photoUIImage
        }
        
        
        

        
        // Title
        cell.singleTopicCellTitle.text = articleItem.title!.noHTMLtag
        
        // Author
        cell.singleTopicCellAuthor.text = articleItem.author
        
        // CellBody without HTML tag
        cell.singleTopicCellBody.text = articleItem.body!.noHTMLtag
        
        
        return cell
    }
    
    
    
    /**
     
     Prepare for segue. When users tap one topic in this viewController, we must prepare the selected data and pass them to next viewcontroller
     - returns: no return just link the file
     
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // prepare to pass data
        let articleDetail = segue.destinationViewController as! ArticleViewController
        
        
        if let indexPath = ArticleInTopicTableView.indexPathForSelectedRow {
            
            // get data according to indexPath.row
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
                articleDetail.currentPhotoUIImage = articleSelected.photoUIImage
            }
            articleDetail.currentTimeString = articleSelected.time
            
        }
    }


}
