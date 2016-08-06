//
//  NewsPaperViewController.swift
//  SportReader
//
//  Created by  Arian Niaki on 5/9/1395 AP.
//  Copyright © 1395 AP  Arian Niaki. All rights reserved.
//

import UIKit
import Kanna

class NewsPaperViewController: UIViewController,UINavigationControllerDelegate {

    

    var newspaper : NewsPaper?
    
    
    @IBOutlet weak var NewsPaperImage: UIImageView!
    
    let alertController = UIAlertController(title: nil, message: "Loading\n\n", preferredStyle: UIAlertControllerStyle.Alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        spinnerIndicator.center = CGPointMake(135.0, 65.5)
        spinnerIndicator.color = UIColor.blackColor()
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.presentViewController(alertController, animated: false, completion: nil)

        loadNewsPaperImage(newspaper!.html)

        // Do any additional setup after loading the view.
    }
    @IBAction func shareButton(sender: AnyObject) {
        displayShareSheet("Please Download our app from : \n"+newspaper!.html)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }

    func loadNewsPaperImage(html: String)
    {
        
        
        let url = NSURL(string: html)
        
        
        if let doc_newspaper = HTML(url: url!, encoding: NSUTF8StringEncoding) {
            print("------")
            if doc_newspaper.at_xpath("//img[@id='newspaper-large-img']//@src")?.toHTML != nil
            {

            let newspaperlink=(doc_newspaper.at_xpath("//img[@id='newspaper-large-img']//@src")!.content)
            print(newspaperlink)
                print("____")
            load_image(newspaperlink!)
            
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
                    self.NewsPaperImage.image = UIImage(data: data!)
                    self.alertController.dismissViewControllerAnimated(true, completion: nil)

                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()

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
