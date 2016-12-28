//
//  ArticleViewController.swift
//  ViewControlller for showing one Article Content Detail
//
//  HealthEdu
//
//  Created by Mac on 2016/9/12.
//  Copyright © 2016年 NCKU_hospital. All rights reserved.
//

import UIKit
import CoreData

class ArticleViewController: UIViewController {
    
    // MARK:- Variable Declaration
    var currentIdString: String?
    
    var currentDivisionString: String?
    
    var currentTitleString: String?
    
    var currentAuthorString: String?
    
    var currentBodyString: String?
    
    var currentTimeString: String?
    
    var currentPhotoUIImage: UIImage?

    // for image storing into core data and recording whether the image is Default
    var imageIsDefault: Bool? = false
    
    // WebView for article Full text
    @IBOutlet var articleFullWebView: UIWebView!
    
    // qrcodeImage
    var qrcodeImage: CIImage!
    
    // URLArray for storing redirecting qrcode url
    var URLArrayforQRCode = [String]()
    
    // storing fontSize
    var fontSizeString :String?

    // for core data
    let core_data = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext



    // MARK:- Basic Func
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    

    /**
     execute once whenever user view this ViewController
     - show navigation Bar button item
     - show article full html in web view
     - delete History of same article 
     - add new history record to core data
     
     - returns: nothing
     */
    override func viewWillAppear(animated: Bool) {

        
        // show bar button item (qrcode, change font size, AddTobookmark)
        self.showBarButtonItem()
        
        // show article Full in web view (get defaults font size)
        self.showarticleFullHTML(self.getDefaultFontSize())
        
        // delete same history
        self.deleteHistoryExist()
        
        // add new record to HistoryEntities
        self.addToHistory()
        
        
    }
    
    /**
     show bar button item here
     
     - returns: nothing
     */
    
    func showBarButtonItem()
    {
        // check if the article is in core data
        let fetchRequest = NSFetchRequest(entityName: "BookmarkEntities")
        fetchRequest.predicate = NSPredicate(format: "id == %@", currentIdString!)
        
        do {
            
            let fetchResults = try self.core_data.executeFetchRequest(fetchRequest) as? [BookmarkEntities]
            
            var button1 = UIBarButtonItem()
            
            if fetchResults!.count > 0 {
                
                // the article already exist, show bookmark black button
                button1 = UIBarButtonItem(image: UIImage(named: "bookmark_black"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.deleteFromBookmark))
                
            }else{
                
                // the article does not exist, show bookmark white button
                button1 = UIBarButtonItem(image: UIImage(named: "bookmark_white"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.addToBookmark(_:)))
                
            }
            
            
            var width =  button1.width
            width = -10
            button1.width = width
            
            
            
            let button2 = UIBarButtonItem(image: UIImage(named: "font_size"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.changeFontSize(_:)))
            
            let button3 = UIBarButtonItem(image: UIImage(named: "qrcode"), landscapeImagePhone: nil, style: .Done, target: self, action: #selector(self.qrcodeBtn(_:)))
            
            
            self.navigationItem.setRightBarButtonItems([button1,button2,button3], animated: false)
            
            
            
            
        }catch{
            
            fatalError("CANT FIND: \(error)")
            
        }
    }

    
    
    
    
    
    // MARK:- Show HTML
    
    
    /**
     show full article HTML
     - parameter fontsize: size of font
     - returns: nothing
     
     */
    func showarticleFullHTML(fontsize: Int){
        

        let divWidth = self.view.frame.size.width-17
        
        let imgWidth = self.view.frame.size.width-17
        
        var articleFullHTMLarray = [String]()
    
        
        articleFullHTMLarray.append("<div width=\"\(divWidth)\"style=\"word-break: break-all;\"")
        
        
        articleFullHTMLarray.append("<br><p><div align=\"center\" style=\"font-size:35px; font-weight:bold;\">\(self.currentTitleString!)</div></p>")
        
        articleFullHTMLarray.append("<p><div align=\"center\" style=\"color: gray; font-size:19px\">\(self.currentAuthorString!)</div></p>")

        // 1) if article has no image
        // 2) if article image is too large too downloaded completely at this point
        // don't show image
        if(UIImageJPEGRepresentation(self.currentPhotoUIImage!,1.0) != UIImageJPEGRepresentation(UIImage.imageWithColor(UIColor.whiteColor()),1.0)!){
            

            // if image is not default, then show image
            if(self.imageIsDefault != true){
            
                // if currentPhotoUIImage not equal to default photo for article (article has no image)
                
                // amazing: UIImageJPEGRepresentation can convert jpeg png gif
                let imageData = NSData(data: UIImageJPEGRepresentation(self.currentPhotoUIImage!,1.0)!)
                
                // change imageData to base64
                let base64Data = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                
                articleFullHTMLarray.append("<img src=\"data:image/jpg;base64,\(base64Data)\" width=\"\(imgWidth)\">")
        
            }
            
            
        }
        
        
        articleFullHTMLarray.append("<div style='font-size: \(fontsize)px; padding-left: 3%; padding-right: 3%;' id=\"body\"><p> \(self.currentBodyString!)</p>")
        
        articleFullHTMLarray.append("<p>最後更新：\(self.currentTimeString!)<br></p></div>")
        
        articleFullHTMLarray.append("</div>")
        
        
        let articleFullHTML = articleFullHTMLarray.joinWithSeparator("")
        
        self.fontSizeString = "正常"
        self.articleFullWebView.loadHTMLString(articleFullHTML, baseURL: nil)
        self.articleFullWebView.backgroundColor = UIColor.whiteColor()
        
        // check if author is (可縮放), if true, set webview to be zoomable
        // it's a trick
        if (self.currentAuthorString == "(可縮放)") {
            // set webview to be zoom
            self.articleFullWebView.scalesPageToFit = true
        }

               
    }
    
    
    
    // MARK:- Bar Button Item Function
    
    /**
     this func will generate a qrcode related to id of the article
     - returns: QRCode UIImage of article id
     */
    func GenerateQRCode(imgview: UIImageView) -> UIImage
    {
        // generate the url array for this article id
        self.URLArrayforQRCode.append("http://ncku.medcode.in/index/redirectArticle/")
        self.URLArrayforQRCode.append(self.currentIdString!)

        // combine all url array to a string
        let realURLStringforQRCode = self.URLArrayforQRCode.joinWithSeparator("")
        
        // variable data is going to be sent to generate a QR Code image
        let data = realURLStringforQRCode.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        
        self.qrcodeImage = filter!.outputImage
        
        // calculate the scale of between size of imgQRCode.frame and qrcodeimage
        let scaleX = imgview.frame.size.width / self.qrcodeImage.extent.size.width
        let scaleY = imgview.frame.size.height / self.qrcodeImage.extent.size.height
        
        
        // change to fit the size of  qrcodeimage
        let transformedImage = self.qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        
        return UIImage(CIImage: transformedImage)
        
    }
    
    
    /**
     press background and alert controller will close
     - returns: nothing
     */
    func alertControllerBackgroundTapped()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /**
     executed when qr code generate button is clicked
     - returns: nothing
     */
    func qrcodeBtn(sender: AnyObject) {
        
        // define what to show in alert controller
        let alertMessage = UIAlertController(title: "請用QRcode掃描！", message: "點擊背景以返回", preferredStyle: .Alert)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertMessage.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 320)
        
        alertMessage.view.addConstraint(height)
        
        
        let imageView = UIImageView(frame: CGRectMake(35, 90, 200, 200))
        
        // call self.GenerateQRCode to return a UIImage
        imageView.image = self.GenerateQRCode(imageView)
        
        alertMessage.view.addSubview(imageView)
        
        self.presentViewController(alertMessage, animated: true, completion:{
            alertMessage.view.superview?.userInteractionEnabled = true
            alertMessage.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
        
    }
    
    /**
     
     executed when qr code generate button is clicked
     change font size
     and store it in NSUserDefaults
     
     */
    func changeFontSize(sender: AnyObject) {
        
        
        
        let alertMessage = UIAlertController(title: "改變文字大小", message: "目前文字大小：\(self.getDefaultFontSizeString())", preferredStyle: .Alert)
        
        
        let sizeSmaller = UIAlertAction(title: "小", style: .Default, handler: { (action) -> Void in
            
            
            let script = "document.getElementById('body').style.fontSize = '19px'"
            self.articleFullWebView.stringByEvaluatingJavaScriptFromString(script)
            self.fontSizeString = "小"
            MoreTextSettingVC.storeFontSizetoUserDefaults(0)
        })
        
        let sizeNormal = UIAlertAction(title: "正常", style: .Default, handler: { (action) -> Void in
            let script = "document.getElementById('body').style.fontSize = '21px'"
            self.articleFullWebView.stringByEvaluatingJavaScriptFromString(script)
            self.fontSizeString = "正常"
            MoreTextSettingVC.storeFontSizetoUserDefaults(1)
        })
        
        let sizeBigger = UIAlertAction(title: "大", style: .Default, handler: { (action) -> Void in
            let script = "document.getElementById('body').style.fontSize = '24px'"
            self.articleFullWebView.stringByEvaluatingJavaScriptFromString(script)
            self.fontSizeString = "大"
            MoreTextSettingVC.storeFontSizetoUserDefaults(2)
        })
        
        let sizeBiggest = UIAlertAction(title: "最大", style: .Default, handler: { (action) -> Void in
            let script = "document.getElementById('body').style.fontSize = '29px'"
            self.articleFullWebView.stringByEvaluatingJavaScriptFromString(script)
            self.fontSizeString = "最大"
            MoreTextSettingVC.storeFontSizetoUserDefaults(3)
            
        })
        
        alertMessage.addAction(sizeSmaller)
        alertMessage.addAction(sizeNormal)
        alertMessage.addAction(sizeBigger)
        alertMessage.addAction(sizeBiggest)
        
        
        self.presentViewController(alertMessage, animated: true, completion:nil)
        // 若有點擊背景以返回功能，則會影響 alert 的 button 功能
        
        
    }
    
    
    // MARK:- user Default
    /**
     
     get user default setting for article font size
     - returns: String 小 正常 大 最大
     
     */
    func getDefaultFontSizeString() -> String {
        
        // userDefault basic variable object
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        
        
        if let storedFontSize = userDefault.objectForKey("fontSizeUserDefaults") {
            
            switch storedFontSize as! Int {
            case 0:
                return "小"
            case 1:
                return "正常"
            case 2:
                return "大"
            case 3:
                return "最大"
            default:
                return "正常"
            }
            
        }else{
            return "正常"
        }
    }
    
    
    /**
     
     get user default font size in Int (px)
     
     - returns: Int, 19,21,24,29
     
     */
    func getDefaultFontSize() -> Int {
        
        // userDefault basic variable object
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        
        
        if let storedFontSize = userDefault.objectForKey("fontSizeUserDefaults") {
            
            switch storedFontSize as! Int {
            case 0:
                return 19
            case 1:
                return 21
            case 2:
                return 24
            case 3:
                return 29
            default:
                return 21
            }
            
        }else{
            
            return 21
            // if key does not exist, return 21 (正常)
            
        }
        
        
    }

    // MARK:- Add To Core Data
    /**
    add article to bookmark
    - returns: nothing
     */
    func addToBookmark(sender: AnyObject) {
        
        // get the biggest autoIncrement in core data now
        let countRequest = NSFetchRequest(entityName: "BookmarkEntities")
        
        // count for current stored bookmark articles
        let fetchResults = core_data.countForFetchRequest(countRequest, error: nil)
        
        // if >= 20 articles now, stop storing process
        if(fetchResults >= 20){
            
            //  means bookmarks store reach the limit 20
            let alertMessage = UIAlertController(title: "已達收藏文章上限(20篇)", message: "請前往書籤-收藏頁面刪除文章！", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "知道了", style: .Default, handler: nil)
            
            
            alertMessage.addAction(okAction)
            
            // need add dispatch
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(alertMessage, animated: true, completion:nil)
            })
            
        }else{
            

            if let bookmark = NSEntityDescription.insertNewObjectForEntityForName("BookmarkEntities", inManagedObjectContext: self.core_data) as? BookmarkEntities {
                

                do {
                    
                    let fetchResults = try self.core_data.executeFetchRequest(countRequest) as? [BookmarkEntities]
                    
                    var biggest:Int? = 0
                    
                    for a_result in fetchResults!{
                        
                        if a_result.autoIncrement != nil {
                            if Int(a_result.autoIncrement!) > biggest {
                                biggest = Int(a_result.autoIncrement!)
                            }
                        }
                        
                    }
                    
                    // autoIncrement = biggest +1
                    if biggest != nil {
                        bookmark.autoIncrement = biggest! + 1
                    }else{
                        bookmark.autoIncrement = 0
                    }
                    
                }catch{
                    
                    fatalError("Failure to save context: \(error)")
                    // can not store
                }
                
                
                bookmark.id = currentIdString
                bookmark.time = currentTimeString
                bookmark.author = currentAuthorString
                bookmark.body = currentBodyString
                bookmark.title = currentTitleString
                bookmark.photoUIImage = NSData(data: UIImageJPEGRepresentation(self.currentPhotoUIImage!,1.0)!)
                bookmark.division = currentDivisionString
                bookmark.imageIsDefault = self.imageIsDefault
                
                do {
                    
                    try self.core_data.save()
                    // store
                    
                    self.showBarButtonItem()
                    // reload bar button
                    
                }catch{
                    
                    fatalError("Failure to save context: \(error)")
                    // can not store
                }
                
                
                
            }
        
        
        }
        
        
        
    }
    
    
    
    

    /**
     
        delete article from bookmark
     
     */
    func deleteFromBookmark()
    {
        
        let deleteRequest = NSFetchRequest(entityName: "BookmarkEntities")
        deleteRequest.predicate = NSPredicate(format: "id == %@", currentIdString!)
        
        do {
            
            let results = try self.core_data.executeFetchRequest(deleteRequest) as! [BookmarkEntities]
            
            for result in results {
                
                self.core_data.deleteObject(result)
                
            }
            
            do {
                
                try self.core_data.save()
                
                self.showBarButtonItem()
                // reload show bar button
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
            }
            
        }catch{
            
            fatalError("Failed to fetch data: \(error)")
            
        }
        
        
    }
    
    /**
     
        delete existing article from History
     
     */
    func deleteHistoryExist()
    {
        let deleteExistRequest = NSFetchRequest(entityName: "HistoryEntities")
        deleteExistRequest.predicate = NSPredicate(format: "id == %@", currentIdString!)
        
        
        // delete existing article from history
        do {
            
            let results = try self.core_data.executeFetchRequest(deleteExistRequest) as! [HistoryEntities]
         
            for result in results {
                
                self.core_data.deleteObject(result)
                
            }
            
            do {
                
                try self.core_data.save()
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
                // can not store
            }
            
        }catch{
            
            fatalError("Failure to save context: \(error)")
            // can not store
        }
    }
    
    
    /**
     
     add article to History
     
     */
    func addToHistory()
    {
        
        
        
        if let history = NSEntityDescription.insertNewObjectForEntityForName("HistoryEntities", inManagedObjectContext: self.core_data) as? HistoryEntities {
            
            
            
            
            // find the biggest autoIncrement value in core data
            let countRequest = NSFetchRequest(entityName: "HistoryEntities")
            
            do {
                
                let fetchResults = try self.core_data.executeFetchRequest(countRequest) as? [HistoryEntities]
                
                let countResults = self.core_data.countForFetchRequest(countRequest, error: nil)
                
       
                
                // declara smallest(for delete old history) and biggest(for add a new article)
                print(Int.max)
                var smallest: Int? = Int.max
                var biggest: Int? = 0
                
                // find the smallest autoIncrement value in core data
                for a_result in fetchResults!{
                    if a_result.autoIncrement != nil {
                        
                        // there seem to be a nil entity in Core Data
                        // use let title = a_result.title to avoid that nil entity
                        // or it will interfere the smallest number we calculate here
                        if a_result.title != nil {
                            
                            if Int(a_result.autoIncrement!) < smallest {
                                
                                smallest = Int(a_result.autoIncrement!)
                                
                            }
                            
                            if Int(a_result.autoIncrement!) > biggest {
                                biggest = Int(a_result.autoIncrement!)
                                
                            }
                            
                        }
                        

                        

                    }
                    
                }
                
                
                // check if count results is over 20
                // when over, delete the smallest autoIncrement article
                // count 21 for autual 20 articles
                if(countResults >= 21){
                    
                    let deleteExistRequest = NSFetchRequest(entityName: "HistoryEntities")
                    deleteExistRequest.predicate = NSPredicate(format: "autoIncrement == %i", smallest!)
                    
                    
                    // delete existing article from history
                    do {
                        
                        let results = try self.core_data.executeFetchRequest(deleteExistRequest) as! [HistoryEntities]
                        
                        for result in results {
                            
                            self.core_data.deleteObject(result)
                            
                        }
                        
                        do {
                            
                            try self.core_data.save()
                            
                        }catch{
                            
                            fatalError("Failure to save context: \(error)")
                            // can not store
                        }
                        
                    }catch{
                        
                        fatalError("Failure to save context: \(error)")
                        // can not store
                    }
                    
                    
                }
                
                
                
                // define History autoIncrement = biggest +1
                if biggest != nil {
                    history.autoIncrement = biggest! + 1
                }else{
                    history.autoIncrement = 0
                }
                
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
                // can not store
            }
            
            history.id = currentIdString
            history.time = currentTimeString
            history.author = currentAuthorString
            history.body = currentBodyString
            history.title = currentTitleString
            history.photoUIImage = NSData(data: UIImageJPEGRepresentation(self.currentPhotoUIImage!,1.0)!)
            history.division = currentDivisionString
            history.imageIsDefault = self.imageIsDefault
            
            do {
                
                try self.core_data.save()
                // store
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
                // can not store
            }
            
            
            
            
        }
    }
    
    

    
    
    
    
    
}
