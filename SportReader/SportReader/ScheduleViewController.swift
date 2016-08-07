//
//  ScheduleViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/10/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna
import AVKit
import AVFoundation

class ScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        dispatch_async(dispatch_get_main_queue(), {
//            self.reloadfunc()
//        })
        
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
                
                self.reloadfunc()
                
                
            }
        }


        
        let swiftColor = UIColor(red: 72/255, green: 150/255, blue: 78/255, alpha: 1)
        navigationController!.navigationBar.barTintColor = swiftColor

        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        print("-----")
        print(items)
        // Do any additional setup after loading the view.
    }

    func reloadfunc()
    {
        items.removeAll()
        print("REMOVED")
        print(items)
        self.scheduleCollectionView.reloadData()

        loadschedule()
        self.scheduleCollectionView.reloadData()
        print("ADDED")
        print(items)
        self.dismissViewControllerAnimated(false, completion: nil)
        

    }
    @IBAction func refreshSchedule(sender: AnyObject) {
       reloadfunc()
    }
    
    func loadschedule(){
    // MARK: reading tv chedule
        let url = NSURL(string: "http://varzesh3.com")
        if let doc2 = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("------")
            let lis=(doc2.at_xpath("//div[@id='tv-schedule']//div[@class='widget-content']//center")!.toHTML)
            //            print (lis)
            
            print("____W_W_W_W")
            let Arr = lis!.componentsSeparatedByString("<p>")
            print(Arr.count)
            for a in Arr {
                let html = a
                if let htmlDoc = HTML(html: html, encoding: NSUTF8StringEncoding) {
                    
                    if(htmlDoc.at_xpath("//a")?.content != nil){
                        print(htmlDoc.at_xpath("//a")!.content)
                        print("DONE")
                         let result = htmlDoc.at_xpath("//a")!.content!.stringByReplacingOccurrencesOfString("\r\n", withString: "")
                        print(result)
                        print("_________")
                        
                        
                        items.append(result)


                    }
                }
            }

            

    }
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ScheduleCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.ScheduleLabel.text = self.items[indexPath.item]

        cell.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249.0/255, alpha: 1.0) // make cell more visible in our example project
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
