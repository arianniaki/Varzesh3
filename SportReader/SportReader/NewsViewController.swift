//
//  NewsViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/8/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna
import AVKit
import AVFoundation

class NewsViewController: UIViewController,UINavigationControllerDelegate {

    var news: News?
    let alertController = UIAlertController(title: nil, message: "Loading\n\n", preferredStyle: UIAlertControllerStyle.Alert)

    // Mark: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var scrollNews: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.numberOfLines = 0
        print(news!.type)
    
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        spinnerIndicator.center = CGPointMake(135.0, 65.5)
        spinnerIndicator.color = UIColor.blackColor()
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.presentViewController(alertController, animated: false, completion: nil)

        
        dispatch_async(dispatch_get_main_queue(), {
            
            if(self.news!.type == "News")
            {
                self.loadNewsText(self.news!.html)
                self.loadNewsDate(self.news!.html)
                if(self.news!.title.containsString("عکس"))
                {
                    self.loadNewsImageAks(self.news!.html)
                }
                else{
                    self.loadNewsImage(self.news!.html)
                }
            }
            else
            {
                self.loadNewsVideo(self.news!.html)
            }
        })

        titleLabel.text=news?.title
        self.alertController.dismissViewControllerAnimated(true, completion: nil)
       
}
    

    @IBAction func shareButton(sender: AnyObject) {
    displayShareSheet("Please Download our app from : \n"+news!.html)
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }

    
    func loadNewsVideo(html: String)
    {
        let url = NSURL(string: html)
        
        if let doc_newsinner = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("------")
            if doc_newsinner.at_xpath("//div[@class='container main']//div[@class='row']//div[@class='col-xs-12 col-md-8 col-lg-9 pull-right']//div[@class='video-player']")?.toHTML != nil
            {
                
                let innernews=(doc_newsinner.at_xpath("//div[@class='container main']//div[@class='row']//div[@class='col-xs-12 col-md-8 col-lg-9 pull-right']//div[@class='video-player']//video//@src")?.content)
                print(innernews)
                
                let videoURL = NSURL(string: innernews!)
                let player = AVPlayer(URL: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.presentViewController(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
            }
        }
        
    }

    func loadNewsImageAks(html: String)
    {
        
        var imagesListArrayString = [String]()

        let url = NSURL(string: html)
        
        if let doc_newsinner = HTML(url: url!, encoding: NSUTF8StringEncoding) {
                        print("------")
                        let innernews=(doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='main-body']")?.toHTML)
            
                        let allmatches = innernews!.componentsSeparatedByString("<p")
                        //                            print(allmatches.count)
                        for item in allmatches
                        {
            
                            let html_news = item
                            if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
                                print("___>")
                                if htmlDoc.at_xpath("//img//@src")?.toHTML != nil {
                                    print(htmlDoc.at_xpath("//img//@src")?.toHTML)
                                    imagesListArrayString.append(htmlDoc.at_xpath("//img//@src")!.content!)
                                }
                                
                            }
                            
                        }
                    }
        var imagesListArray = [UIImage]()
        
        for imageName in imagesListArrayString
        {
            print("************")
            print(imageName)
            print("&&&&&&&&&&&&")
            
            if let url = NSURL(string: imageName) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    if(!imageName.containsString("telegram"))
                    {imagesListArray.append(image!)}

                }        
            }
        }
        
        print(imagesListArray)
        print(imagesListArray.count)
        
        self.newsImage.animationImages = imagesListArray
        self.newsImage.animationDuration = 10.0
        self.newsImage.startAnimating()

    }

    
    
    func loadNewsImage(html: String)
    {
//
        let url = NSURL(string: html)

        if let doc_newsinner = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("------")
            if doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='NewsTable']//tbody//img//@src")?.toHTML != nil
            {

                
                
            let innernews=(doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='NewsTable']//tbody//img//@src")?.content)
            print(innernews)
            load_image(innernews!)
        }
            else{
                loadNewsImageAks(self.news!.html)
            }
        }

    }
    
    func loadNewsText(html : String) {
        
        // MARK: football reading inner news
        let url = NSURL(string: html)
        
        if let doc_newsinner = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("----,,,--")
            if doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='main-body']//p")?.toHTML != nil
            {
   
            let innernews=(doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='main-body']//p")?.content)
                
                
                let text2 = innernews!.stringByReplacingOccurrencesOfString("\r\n", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
//                print(text2)
                let result = text2.stringByReplacingOccurrencesOfString("\n\n", withString: "\n")

                print("----nnn--")

                
                newsText.text=result

            }
        
    }
    }

        func loadNewsDate(html : String) {
            

            let url = NSURL(string: html)
            
            
            if let doc_newsinner = HTML(url: url!, encoding: NSUTF8StringEncoding) {
                print("------")
                if doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='NewsTable']//tbody//tr")?.toHTML != nil
                {
                    let innernews=(doc_newsinner.at_xpath("//div[@id='news-col-right']//div[@id='anc']//div[@id='anc-op']//tbody//table[@id='NewsTable']//tbody//tr")?.content)
                    print(innernews!)
                    if innernews!.rangeOfString("زمان") != nil{
                        print("exists")
                        print(innernews!.rangeOfString("زمان"))
                        
                        
                        let subStr = innernews![innernews!.startIndex.advancedBy(129)...innernews!.startIndex.advancedBy(153)]
                        print(subStr)
                        newsDate.text=subStr

                }
                    
                
            }
    }
        }
    
    
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.newsImage.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    


    

}

