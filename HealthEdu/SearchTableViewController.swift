//
//  SearchTableViewController.swift
//  ViewController for Search bar and showing recommended keywords
//
//  HealthEdu
//
//  Created by Mac on 2016/9/12.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK:- Variable Declaration
    
    // Offline Data for now. Recommended Keywords
    var hotSearchItem: [String] = []
    
    // trend search item
    var trendSearchItem: [String] = []
    
    // Variable for containing searchBar
    let searchBar = UISearchBar.self
    
    // contain text to search when button return clicked
    var searchTextTemp: String?
    
    // for marking whether user type in something to search or not
    var showSearhResult = false

    // section title for hot
    var sectionTitleForHot: String = ""
    
    // section title for hot
    var sectionTitleForTrend: String = ""
    
    // id contain article id from AppDelegate.swift (qrcode)
    static var idFromQrcode: String?
    
    // contain article download from ShowArticleForQrcode
    var articleData: article?
    
    // initiate refreshControl
    var refreshController: UIRefreshControl!
    
    @IBOutlet var searchHotTrendTextActivityIndicator: UIActivityIndicatorView!

    
    
    // MARK:- Basic Func
    override func viewWillAppear(animated: Bool) {
        // check if user is connected to interent
        // show alert if not
        Reachability.checkInternetAndShowAlert(self)
        
        // custom extension of UITableView to deselect selected row
        self.tableView.deselectSelectedRow(animated: true)
        
        
        if(SearchTableViewController.idFromQrcode != nil){
            
            ShowArticleForQrcode.byArticleId(SearchTableViewController.idFromQrcode!, completionHandler:{
                (idValid,singleArticle) in
                
                // everything good, id is valid, article is downloaded successfully
                if(idValid == true){
                    
                    self.articleData = singleArticle
                    
                    SearchTableViewController.idFromQrcode = nil
                    
                    
                    // change UI inside main queue
                    dispatch_async(dispatch_get_main_queue(), {
                        // perform segue change vc
                        self.performSegueWithIdentifier("qrcodeArticleShowSegue", sender: self)
                    })
                    
                }else{
                    // id is invalid, and server show error
                    
                    
                    // show error here
                    let alertMessage = UIAlertController(title: "Qrcode條碼失效", message: "請再掃描一次，或改用文字搜尋功能！", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
                    
                    
                    alertMessage.addAction(okAction)
                    
                    // need add dispatch
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(alertMessage, animated: true, completion:nil)
                    })
                    

                    
                }

                
                
                
            })
            
            
        }else{
            print("idFromQrcode is nil")
        }
        
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // change activityIndicator color to blue (default iOS blue)
        self.searchHotTrendTextActivityIndicator.color = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        // init activityIndicator Animating
        self.searchHotTrendTextActivityIndicator.startAnimating()
        
        
        // not to display UITableView separator style
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        // remove separate line for empty cell
        self.tableView.tableFooterView = UIView()
        
        // define refreshControl
        self.refreshController = UIRefreshControl()
        
        // set refreshControl color
        self.refreshController.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 0.7)
        
        // addTarget when pull, which func to exe
        self.refreshController.addTarget(self, action: #selector(SearchTableViewController.download), forControlEvents: UIControlEvents.ValueChanged)


        // start the whole thing
        self.download()
        
        
        
    }
    
    
    func download(){
        
        ListSearchDefaultText.hotANDtrend({
            (hotArray, trendArray, error) in
            
            if error != nil {
                // there is error
                // change UI inside main queue
                
                switch error! {
                    
                case "code-1009":
                    
                    // define 3 seconde for dispathc after
                    let threeSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    
                    dispatch_after(threeSeconds, dispatch_get_main_queue()) {
                        
                        
                        print("請連上網路後，下拉重新整理。")
                        
                        // set hot and trend both to nothing
                        self.hotSearchItem = []
                        self.trendSearchItem = []
                        
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
                        
                        // set hot and trend both to nothing
                        self.hotSearchItem = []
                        self.trendSearchItem = []
                        
                        self.refreshController.endRefreshing()
                        
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                        self.tableView.showNoRowInfo("網速過慢、或連線出現問題。")
                        
                        if(!self.refreshController.isDescendantOfView(self.tableView)){
                            self.tableView.addSubview(self.refreshController)
                        }
                        
                        
                    }
                    
                }
                
                
                
                
            }else{
                
                
                self.hotSearchItem = hotArray
                self.trendSearchItem = trendArray
                
                // define 3 seconde for dispathc after
                let oneSeconds = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
                
                dispatch_after(oneSeconds, dispatch_get_main_queue()) {
                    
                    self.tableView.backgroundView = nil
                    
                    // stop activity indicator animating
                    self.searchHotTrendTextActivityIndicator.stopAnimating()
                    self.searchHotTrendTextActivityIndicator.hidden = true
                    
                    self.sectionTitleForHot = "📈 最新趨勢"
                    self.sectionTitleForTrend = "♨ 熱門關鍵字"
                    
                    
                    
                    // show the line separator again
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    
                    if self.hotSearchItem.count == 0 || self.trendSearchItem.count == 0 {
                        
                        // no need to do below line in dispathc main
                        // because table reloadData() method is already in dispatch main
                        self.tableView.showNoRowInfo("目前沒有趨勢、或熱門搜尋關鍵字。")
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
                        
                    }else{
                    
                        UIView.transitionWithView(self.tableView, duration: 1.0, options: .TransitionCrossDissolve , animations: {self.tableView.reloadData()}, completion: nil)
                        
                        
                    }
                    
                    self.refreshController.endRefreshing()
                    
                    
                    if(!self.refreshController.isDescendantOfView(self.tableView)){
                        self.tableView.addSubview(self.refreshController)
                    }
                    
                    
                }
            
            
            
            }
        
            
        })
        
        // create search bar and add gesture
        self.createSearchBar()
        
    }
    
    


    // MARK:- Specific funcs for search functionality

    func createSearchBar(){
        
        // create search bar func
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        
        // placeholder
        searchBar.placeholder = "搜尋：請在此輸入關鍵字"
        searchBar.delegate = self
        
        // put search bar on
        self.navigationItem.titleView = searchBar
        
        // createtap Gesture Recognizer
        // trigger hideKeyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchTableViewController.hideKeyboard))
        
        // without this line, the table behind keyboard cannot be clicked
        tap.cancelsTouchesInView = false
        
        // add gesture to view
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    /**
     hide keyboard func
     
     - returns: nothing
     */
    func hideKeyboard(){
        
        self.navigationItem.titleView!.endEditing(true)
        
    }
    

    
    /**
     press on keyboard's "return" button trigger this func
     then it dismiss keyboard, temporarily store searchText, and preform segue
     
     - returns: nothing
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        
        // dismiss keyboard
        searchBar.endEditing(true)
        
        // 檢查不能是空直
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if searchBar.text!.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            
            // string contains non-whitespace characters
            
            // temporary store searchBar text to searchTextTemp
            self.searchTextTemp = searchBar.text
            
            // perform segue change vc
            self.performSegueWithIdentifier("searchTextSendSegue", sender: nil)

            
        }
        
        
        
        
    }


    
    

    // MARK: - Table view data source

    /**
        Define how many section are there
        - returns: Int , section number, in this case just one
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        // return the number of sections
        if self.hotSearchItem.count == 0 || self.trendSearchItem.count == 0 {
            return 0
        }else{
            return 2
        }
        
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        
        if section == 0 {
            return self.sectionTitleForHot
        }else{
            return self.sectionTitleForTrend
        }
        
    }
    
    
    /**
     Define how rows in each section
     In this case, only one section. So, no need to use variable section
     
     - returns: Int , row number
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // differential section row
        if section == 0 {
            return hotSearchItem.count
        }else{
            return trendSearchItem.count
        }
            


        
    }
    

    /**
     Define content of each row
     In this case, only one section. So, no need to use variable section
     
     - returns: UITableViewCell , row number
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Define identifier searchCell
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        
        // differential section row
        if indexPath.section == 0 {
            
            // user do not type anything -> show original hotSearchItem array
            cell.textLabel?.text = hotSearchItem[indexPath.row]
            
        }else{
            
            // user do not type anything -> show original trendSearchItem array
            cell.textLabel?.text = trendSearchItem[indexPath.row]
            
        }
        


        
        
        
        return cell
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // assure identifier to be searchTextSendSegue
        if(segue.identifier == "searchTextSendSegue"){
            // check if segue is trigger from click on tableView
            // YES for execute this if clause, extract text to search from array
            // NO for skip it
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // differential section row
                if indexPath.section == 0 {
                    
                    self.searchTextTemp = hotSearchItem[indexPath.row]
                    
                }else{
                    
                    self.searchTextTemp = trendSearchItem[indexPath.row]
                    
                }
                
                
            }
            
            
            // set SearchResultVC
            let searchResultVC = segue.destinationViewController as! SearchResultVC
            
            // pass data to SearchResultVC
            searchResultVC.searchText = self.searchTextTemp
            
            
        }else if(segue.identifier == "qrcodeArticleShowSegue"){
            
            // segue is from qrcode launch
            
            // set SearchResultVC
            let articleVC = segue.destinationViewController as! ArticleViewController
            
            // pass data to articleVC
            articleVC.currentIdString = self.articleData!.id
            articleVC.currentTitleString = self.articleData!.title
            articleVC.currentBodyString = self.articleData!.body
            articleVC.currentAuthorString = self.articleData!.author
            articleVC.currentDivisionString = self.articleData!.division
            
            // qrcode launch article do not show image
            articleVC.imageIsDefault = true
            
            // but store by default, its image is DefaultPhotoForArticle
            articleVC.currentPhotoUIImage = UIImage(named: "DefaultPhotoForArticle")

            articleVC.currentTimeString = self.articleData!.time

            
        }

        
        
        
    }
    
    


}
