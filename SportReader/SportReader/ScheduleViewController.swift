//
//  ScheduleViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/10/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna

class ScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = [String]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        loadschedule()
        print("-----")
        print(items)

        // Do any additional setup after loading the view.
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
            for a in Arr {
                let html = a
                //                print(a)
                //                print("NETX_______________")
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
        cell.backgroundColor = UIColor.lightGrayColor() // make cell more visible in our example project
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
