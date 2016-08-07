//
//  NewsTableViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/8/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna

class NewsTableViewController: UITableViewController {
    // MARK: Properties
    
    var news = [News]()

    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBAction func Reload(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        loadNews()

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .Alert)
            
            alert.view.tintColor = UIColor.blackColor()
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            self.presentViewController(alert, animated: true, completion: nil)

            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.loadNews()

                

            }
        }
        let swiftColor = UIColor(red: 72/255, green: 150/255, blue: 78/255, alpha: 1)
        navigationController!.navigationBar.barTintColor = swiftColor
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
        
//        dispatch_async(dispatch_get_main_queue(), {
//        })

        

    }
    

    
    
    func loadNews() {
        news.removeAll()

        tableView.reloadData()
        
        let url = NSURL(string: "http://varzesh3.com")

        if let doc_news = HTML(url: url!, encoding: NSUTF8StringEncoding) {
//            print("------")
            let lis_news=(doc_news.at_xpath("//div[@id='widget3']//div[@class='widget-content']//div[@id='footballnewsbox']//ul")?.toHTML)
            //            print(lis_news)
            let Arr_news = lis_news!.componentsSeparatedByString("<li ")
            for a_news in Arr_news {
                let html_news = a_news
                if (a_news.containsString("filter=\"4\"")) || (a_news.containsString("filter=\"8\""))
                {
                if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
                    if htmlDoc.at_xpath("//p//a/@title")?.toHTML != nil
                    {
//                        print(htmlDoc.at_xpath("//p//a/@title")?.toHTML)
                        news.append(News(title:(htmlDoc.at_xpath("//p//a/@title")!.content)!, html:(htmlDoc.at_xpath("//p//a/@href")!.content)!, type: "Video"))
                    }
                }
                }
                
                else
                {
                    if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
                        if htmlDoc.at_xpath("//p//a/@title")?.toHTML != nil
                        {
                            //                        print(htmlDoc.at_xpath("//p//a/@title")?.toHTML)
                            news.append(News(title:(htmlDoc.at_xpath("//p//a/@title")!.content)!, html:(htmlDoc.at_xpath("//p//a/@href")!.content)!,type: "News"))
                        }
                    }

                }
            }
            tableView.reloadData()
            self.dismissViewControllerAnimated(false, completion: nil)


            
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "NewsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let ite = news[indexPath.row]
        
        if ite.type == "Video"
        {
            let photo1 = UIImage(named: "video")!
            

            cell.newsTypeImage.image = photo1
            
             cell.newsTypeImage.image =  cell.newsTypeImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            let swiftColor = UIColor(red: 72/255, green: 150/255, blue: 78/255, alpha: 1)

             cell.newsTypeImage.tintColor = swiftColor

        }
        else
        {
            let photo1 = UIImage(named: "news")!
            
            cell.newsTypeImage.image = photo1
            
        }
        cell.newsTitle.text = ite.title
//        cell.newsImage.image = ite.photo
        
        
        return cell
        
        
            }
    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let newsDetailViewController = segue.destinationViewController as! NewsViewController
            
            // Get the cell that generated this segue.
            if let selectedNewsCell = sender as? NewsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedNewsCell)!
                let selectedNews = news[indexPath.row]
//                print(selectedNews.title)
                newsDetailViewController.news = selectedNews


            }
        }
        
            
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
