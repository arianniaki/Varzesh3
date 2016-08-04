//
//  NewsPaperTableViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/9/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna

class NewsPaperTableViewController: UITableViewController {
    
    // MARK: Properties
    var newspapers = [NewsPaper]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftColor = UIColor(red: 72/255, green: 150/255, blue: 78/255, alpha: 1)
        navigationController!.navigationBar.barTintColor = swiftColor

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            loadNewsPaper()
            
        } else {
            print("Internet connection FAILED")
            var alert=UIAlertController(title: "No Internet Connection", message: "Turn on cellular data or use Wi-Fi to access data.", preferredStyle: UIAlertControllerStyle.Alert);
            
            
            
            func SettingsHandler(actionTarget: UIAlertAction){
                UIApplication.sharedApplication().openURL(NSURL(string:"prefs:root=Cellular")!)
            }
            func OKHandler(actionTarget: UIAlertAction){
            }
            //event handler with predefined function
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: OKHandler));
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: SettingsHandler));
            
            
            presentViewController(alert, animated: true, completion: nil);
            
        
            
        }
        
        self.tableView.rowHeight = 200;
        //Navigation bar coloring
//        navigationController!.navigationBar.barTintColor = UIColor(red: 122.0/255, green: 123.0/255, blue: 125.0/255, alpha: 1.0)

      
    }
    
    func loadNewsPaper(){
        print("newspaper tableview contrller")
        
        let newspaper = NSURL(string: "http://www.varzesh3.com/newspaper")
        
        if let doc_newspaper = HTML(url: newspaper!, encoding: NSUTF8StringEncoding) {
            print("------")
            let newspaperlink=(doc_newspaper.at_xpath("//div[@class='news']//div[@id='newspaper-thumbs-container']")?.toHTML)
            
            let Arr_newspaper = newspaperlink!.componentsSeparatedByString("<!--/.thumb-wrapper-->")
            
            
            for a_news in Arr_newspaper {
                let html_news = a_news
                
                if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
                    //                    print(htmlDoc.at_xpath(("//a[@class='thumb-container']")))
                    if htmlDoc.at_xpath(("//a[@class='thumb-container']"))?.toHTML != nil
                    {
                        
                        print(htmlDoc.at_xpath("//a[@class='thumb-container']//@href")!.content!)
                        
                        if htmlDoc.at_xpath("//a[@class='thumb-container']//label")?.toHTML != nil
                        {
                            print(htmlDoc.at_xpath("//a[@class='thumb-container']//label")!.content!)
                            
                            newspapers.append(NewsPaper(html: htmlDoc.at_xpath("//a[@class='thumb-container']//@href")!.content!,title:htmlDoc.at_xpath("//a[@class='thumb-container']//label")!.content! , tinyimage:htmlDoc.at_xpath("//a[@class='thumb-container']//img//@src")!.content!))
                            
                            
                            
                        }
                        
                    }
                    
                }
            }
            
            
            
        }

    }
    
    @IBAction func refreshNewsPaper(sender: AnyObject) {
        
        newspapers.removeAll()
        
        
        
        print("REMOVED")
        
        self.tableView.reloadData()
        
        let alert = UIAlertController(title: nil, message: "Reloading...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        loadNewsPaper()
        self.tableView.reloadData()
        print("ADDED")
        print(newspapers)
        dismissViewControllerAnimated(false, completion: nil)
        
        

    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newspapers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "NewsPaperTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsPaperTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let ite = newspapers[indexPath.row]
        
        //        cell.newspaperImage.image = ite.photo
        cell.newspaperTitle.text = ite.title

        let url = NSURL(string: ite.tinyimage)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                cell.newspaperImage.image = UIImage(data: data!)
            });
        }
        
        print(ite.title)
        
        
        
        return cell
        
        
    }
    
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let newspaperDetailViewController = segue.destinationViewController as! NewsPaperViewController
            
            // Get the cell that generated this segue.
            if let selectedNewsPaperCell = sender as? NewsPaperTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedNewsPaperCell)!
                let selectedNewsPaper = newspapers[indexPath.row]
                print(selectedNewsPaper.html)
                newspaperDetailViewController.newspaper = selectedNewsPaper
                
            }
        }
        
        
        
    }
    
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
