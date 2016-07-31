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
        
        let alert = UIAlertController(title: nil, message: "Reloading...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        loadNews()
        dismissViewControllerAnimated(false, completion: nil)

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNews()

    }
    

    
    
    func loadNews() {
        news.removeAll()

        tableView.reloadData()

        let url = NSURL(string: "http://varzesh3.com")

        if let doc_news = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("------")
            let lis_news=(doc_news.at_xpath("//div[@id='widget3']//div[@class='widget-content']//div[@id='footballnewsbox']//ul")?.toHTML)
            //            print(lis_news)
            let Arr_news = lis_news!.componentsSeparatedByString("<li ")
            print(Arr_news.count)
            for a_news in Arr_news {
                let html_news = a_news
                if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
                    if htmlDoc.at_xpath("//p//a/@title")?.toHTML != nil
                    {
//                        print(htmlDoc.at_xpath("//p//a/@title")?.toHTML)
                        news.append(News(title:(htmlDoc.at_xpath("//p//a/@title")!.content)!, html:(htmlDoc.at_xpath("//p//a/@href")!.content)!))
                    }
                }
                
            }
            tableView.reloadData()

            
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
                print(selectedNews.title)
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
