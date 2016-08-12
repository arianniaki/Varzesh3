//
//  LiveScoreViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/11/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna

class LiveScoreViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var refreshScore: UIBarButtonItem!

    @IBOutlet weak var livescoreCollectionView: UICollectionView!
    let reuseIdentifier = "LiveCell" // also enter this string as the cell identifier in the storyboard
    var items_team1 = [String]()
    var items_team2 = [String]()
    var items_score = [String]()
    var items_matchstatus = [String]()
    var items_gamedate = [String]()
    var items_gametime = [String]()


    
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
                
                self.reloadfunc()                
                
                
            }
        }
        
        
//        dispatch_async(dispatch_get_main_queue(), {
//            self.reloadfunc()
//        })
//        
        let swiftColor = UIColor(red: 27/255, green: 138/255, blue: 53/255, alpha: 1)
        navigationController!.navigationBar.barTintColor = swiftColor

        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        
//        print("-----11")
//        print(items_team1)
//        print(items_team2)
//        print(items_score)
//        print("-----22")
        print(items_gamedate)

        // Do any additional setup after loading the view.
    }

    func reloadfunc()
    {
        items_score.removeAll()
        items_team1.removeAll()
        items_team2.removeAll()
        items_matchstatus.removeAll()
//        print("REMOVED")
//        print(items_matchstatus)
        self.livescoreCollectionView.reloadData()
        loadlivescore()
        self.livescoreCollectionView.reloadData()
//        print("ADDED")
//        print(items_matchstatus)
       self.dismissViewControllerAnimated(false, completion: nil)
        
        

    }
    
    @IBAction func reloadlivescore(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        reloadfunc()
        
        
    }
    
    func loadlivescore(){
        // MARK: reading tv chedule
        let url = NSURL(string: "http://www.varzesh3.com/livescore")
        if let doc_livescore = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("------")
            
             let livescorelink=(doc_livescore.at_xpath("//div[@id='main']")?.toHTML)
            
            let allmatches = livescorelink!.componentsSeparatedByString("<div class=\"stage-wrapper sport0\"")
            for item in allmatches
            {
                print("+__________________+")
                let matches = item.componentsSeparatedByString("<div class=\"match-row")
                

                
                print(matches.count)
                
                for match in matches
                {
                    
                    
                    if(!match.containsString("score-5div")) //deleting volleyball
                    {
                    let html_news = match
                    if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
//                        print(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname right']")?.toHTML)
//                        print(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname left']")?.toHTML)
//                        print(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='scores-container']")?.content)

                        if(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname right']")?.content != nil){
//                            print(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname right']")?.content)
                            let result = htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname right']")?.content!
                            
                            items_team1.append(result!)
                            
                            
                        }
                        
                        if(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname left']")?.content != nil){
//                            print(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname left']")?.content)
                            let result = htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname left']")?.content!
                            
                            items_team2.append(result!)
                            
                            

                        
                    }
                        
                        if(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='scores-container']")?.content != nil){
//                            print(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='scores-container']")?.content)
                            let result = htmlDoc.at_xpath("//div[@class='team-names']//div[@class='scores-container']")?.content!
                            
                            
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\r\n                                        ", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")

                            
//                            print(trimmed.stringByReplacingOccurrencesOfString("\n", withString: ""))
                            
                            
                            
//                            print(trimmedString.stringByReplacingOccurrencesOfString("                                        ", withString: "" ).stringByReplacingOccurrencesOfString("                                        ", withString: "").stringByReplacingOccurrencesOfString("\n", withString:""))

                            //                            print(trimmed.replace("\n", withString: "").stringByReplacingOccurrencesOfString("                                                    ", withString: ""))
                            
                             items_score.append(trimmed.stringByReplacingOccurrencesOfString("\n", withString: ""))
                        }
                        
                        if(htmlDoc.at_xpath("//div[@class='match-status']//span")?.content != nil){
//                            print(htmlDoc.at_xpath("//div[@class='match-status']//span")?.content)
                            let result = htmlDoc.at_xpath("//div[@class='match-status']//span")?.content!

                            let trimmed=result!.stringByReplacingOccurrencesOfString("\r\n", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")

                            items_matchstatus.append(trimmed)
                            
                            
                            
                            
                        }
                        
                        if(htmlDoc.at_xpath("//div[@class='start-date']")?.content != nil){
                            
//                            print(htmlDoc.at_xpath("//div[@class='start-date']")?.content)
                            let result = htmlDoc.at_xpath("//div[@class='start-date']")?.content!
                            
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")
                            
                            items_gamedate.append(trimmed)
                            
                            
                            
                            
                        }

                        if(htmlDoc.at_xpath("//div[@class='start-time']")?.content != nil){
                            
//                            print(htmlDoc.at_xpath("//div[@class='start-time']")?.content)
                            let result = htmlDoc.at_xpath("//div[@class='start-time']")?.content!
                            
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")
                            
                            
                            items_gametime.append(trimmed)
                            
                            
                            
                            
                        }


                }
                
            
            }
                
            }
        }
    }
    }
    
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items_team2.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LiveScoreCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        cell.Team2.text = self.items_team2[indexPath.item]
        cell.Team1.text = self.items_team1[indexPath.item]
        cell.LiveScore.text = self.items_score[indexPath.item]
        cell.MatchStatus.text = self.items_matchstatus[indexPath.item]
        cell.gameDate.text = self.items_gamedate[indexPath.item]
        cell.GameTime.text = self.items_gametime[indexPath.item]
        print("GMAE TIME ---->")
        print(cell.MatchStatus.text)
        if(cell.MatchStatus.text!.containsString("نهایی"))
        {
            cell.MatchStatus.textColor = UIColor.redColor()
        }
        else
        {
            let swiftColor = UIColor(red: 27/255, green: 138/255, blue: 53/255, alpha: 1)
            cell.MatchStatus.textColor = swiftColor

        }


        
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
