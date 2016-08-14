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
    var livescores = [Livescore]()

    @IBOutlet weak var refreshScore: UIBarButtonItem!

    @IBOutlet weak var livescoreCollectionView: UICollectionView!
    let reuseIdentifier = "LiveCell" // also enter this string as the cell identifier in the storyboard
    //var items_team1 = [String]()
    //var items_team2 = [String]()
    //var items_score = [String]()
    //var items_matchstatus = [String]()
    //var items_gamedate = [String]()
    //var items_gametime = [String]()

    var team1: String = ""
    var team2: String = ""
    var score: String = ""
    var matchstatus: String = ""
    var gametime: String = ""
    var gamedate: String = ""
    var stage : String = ""
    
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
//        print(items_gamedate)

        // Do any additional setup after loading the view.
    }

    func reloadfunc()
    {
        livescores.removeAll()
//        items_score.removeAll()
//        items_team1.removeAll()
//        items_team2.removeAll()
//        items_matchstatus.removeAll()
        print("REMOVED")
        
        self.livescoreCollectionView.reloadData()
        loadlivescore()
        self.livescoreCollectionView.reloadData()
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
                stage = ""
                print("+__________________+")
                
                
                let find: Character = ">"
                if let index = item.characters.indexOf(find) {
                    let pos = item.startIndex.distanceTo(index)
                    print("Found \(find) at position \(pos)")
                    let wholestage = (item[item.startIndex..<item.startIndex.advancedBy(pos)])
                    let findstage: Character = "-"
                    if let index = wholestage.characters.indexOf(findstage) {
                        let pos = wholestage.startIndex.distanceTo(index)
                        print("Found \(findstage) at position \(pos)")
                        let temp = (wholestage[wholestage.startIndex.advancedBy(pos)..<wholestage.endIndex])
                        stage = temp[temp.startIndex.advancedBy(1)..<temp.endIndex.predecessor()]
                    }

                    
                }
                
                
                

                


                let matches = item.componentsSeparatedByString("<div class=\"match-row")
                print(matches.count)
                
                for match in matches
                {
                    if(!match.containsString("score-5div")) //deleting volleyball
                    {
                        team1 = ""
                        team2 = ""
                        score = ""
                        matchstatus = ""
                        gametime = ""
                        gamedate = ""
                        
                    let html_news = match
                    if let htmlDoc = HTML(html: html_news, encoding: NSUTF8StringEncoding) {
                        if(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname right']")?.content != nil){
                            let result = htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname right']")?.content!
                            //items_team1.append(result!)
                            team1 = result!
                        }
                        if(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname left']")?.content != nil){
                            let result = htmlDoc.at_xpath("//div[@class='team-names']//div[@class='teamname left']")?.content!
                          //  items_team2.append(result!)
                            team2 = result!
                    }
                        if(htmlDoc.at_xpath("//div[@class='team-names']//div[@class='scores-container']")?.content != nil){
                            let result = htmlDoc.at_xpath("//div[@class='team-names']//div[@class='scores-container']")?.content!
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\r\n                                        ", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")
                           //  items_score.append(trimmed.stringByReplacingOccurrencesOfString("\n", withString: ""))
                            let temp = trimmed.stringByReplacingOccurrencesOfString("\n", withString: "")
                            score = String(temp.characters.reverse()).stringByTrimmingCharactersInSet(
                                NSCharacterSet.whitespaceAndNewlineCharacterSet())
                            
                        }
                        if(htmlDoc.at_xpath("//div[@class='match-status']//span")?.content != nil){
                            let result = htmlDoc.at_xpath("//div[@class='match-status']//span")?.content!
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\r\n", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")
                           // items_matchstatus.append(trimmed)
                            matchstatus = trimmed
                        }
                        if(htmlDoc.at_xpath("//div[@class='start-date']")?.content != nil){
                            let result = htmlDoc.at_xpath("//div[@class='start-date']")?.content!
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")
//                            items_gamedate.append(trimmed)
                            gamedate = trimmed
                        }
                        if(htmlDoc.at_xpath("//div[@class='start-time']")?.content != nil){
                            let result = htmlDoc.at_xpath("//div[@class='start-time']")?.content!
                            let trimmed=result!.stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString("                                                        ", withString: "")
//                            items_gametime.append(trimmed)
                            gametime = trimmed
                        }
                }
                       
                     

                    }
                    
 
                    if (!team1.isEmpty)
                    {
                        print("ADDKNGFG " + team1)
                        livescores.append(Livescore(team1: team1, team2: team2, livescore: score, matchstatus: matchstatus, gameDate: gamedate, gameTime: gametime, stage: stage))
                    }

                }
                
        }
            
    }
        
    }
    
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.livescores.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LiveScoreCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        cell.Team2.text = self.livescores[indexPath.item].team2
        cell.Team1.text = self.livescores[indexPath.item].team1
        cell.LiveScore.text = self.livescores[indexPath.item].livescore
        cell.MatchStatus.text = self.livescores[indexPath.item].matchstatus
        cell.gameDate.text = self.livescores[indexPath.item].gameDate
        cell.GameTime.text = self.livescores[indexPath.item].gameTime
        cell.stage.text = self.livescores[indexPath.item].stage
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
