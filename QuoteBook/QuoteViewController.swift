//
//  QuoteViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 26/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import Social

class QuoteViewController: UIViewController {
    
    var quote:Quote = Quote()
    var index:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = QuoteView.instanceFromNib()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let view = self.view as? QuoteView {
            view.settingsButton.hidden = true
            view.shareButton.hidden = true
            view.backButton.hidden = true
            //view.settingsButton.addTarget(self, action: "handleSettingsTap:", forControlEvents: .TouchUpInside )
            view.shareButton.addTarget(self, action: "showSharingOptions:", forControlEvents: .TouchUpInside)
            view.backButton.addTarget(self, action: "removeViewController:", forControlEvents: .TouchUpInside)
            
            //Add the tap gesture to the view
            let tapGesture = UITapGestureRecognizer(target: self, action: "toggleSettingsButton:")
            view.addGestureRecognizer(tapGesture)
        }
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleSettingsButton( tapGesture:UITapGestureRecognizer ){
        guard self.quote.tag != ERROR else{ return }
        if let view = self.view as? QuoteView {
            //TODO: Add animation to remove the button after 3 seconds
            UIView.animateWithDuration(1.1, animations: {
                //We are no longeer showing the settings button
                //view.settingsButton.hidden = !view.settingsButton.hidden
                view.shareButton.hidden = !view.shareButton.hidden
                view.backButton.hidden = !view.backButton.hidden
                //Dont show the add Button, yet :)
                //view.addQuoteButton.hidden = !view.addQuoteButton.hidden
            }, completion: nil)
        }
    }
    
    func removeViewController( button:UIButton ){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func handleSettingsTap( button:UIButton ){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tableVC = storyboard.instantiateViewControllerWithIdentifier("SettingsController") as! UITableViewController
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
    
    func showSharingOptions( button:UIButton ){
        let optionsController = UIAlertController(title: "Share", message: "Choose a social media platform", preferredStyle: .ActionSheet )
        let shareText = quote.quote! + "\n-\(quote.author!)\nvia QuoteBook App";
        
        func showErrorAlert( message:String ){
            let errorAlert = UIAlertController(title: "Oops", message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            errorAlert.addAction(cancelAction)
            presentViewController(errorAlert, animated: true, completion: nil)
        }
        
        //Twitter Action
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default, handler: { (twitterAction) in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                let tweet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweet.setInitialText(shareText)
                self.presentViewController(tweet, animated: true, completion: nil)
            }else{ showErrorAlert("No Twitter Account configured") }
        })
        //FaceBook
//        let facebookAction = UIAlertAction(title: "FaceBook", style: .Default, handler: { (fbAction) in
//            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
//                let fbVC:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//                fbVC.setInitialText(shareText)
//                self.presentViewController(fbVC, animated: true, completion: nil)
//            }else{ showErrorAlert("No FaceBook Account configured") }
//        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionsController.addAction(twitterAction)
        //optionsController.addAction(facebookAction)
        optionsController.addAction(cancelAction)
        optionsController.modalPresentationStyle = .Popover
        if let popover:UIPopoverPresentationController = optionsController.popoverPresentationController{
            if let view = self.view as? QuoteView {
                popover.sourceView = view.shareButton
                popover.sourceRect = view.shareButton.bounds
            }
        }
        self.presentViewController(optionsController, animated: true, completion: nil)
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettings" {
            let _ = segue.destinationViewController as! UITableViewController
        }
    }

}
