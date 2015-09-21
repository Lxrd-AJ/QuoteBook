//
//  AppDelegate.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 21/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("z3rPfifyHvVjZh2U9KsWOEQz9GOWPOYc1o8LCfDk", clientKey: "6EIPhRpX5apNxkqkeiwZ2MIJ3nR0CIBUBoSNYz51")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Setup
        let view = QuoteView.instanceFromNib()
        view.titleLabel.text = "QuoteBook App"
        view.quoteTextView.text = "Patience is a virtue \n\nFetching your quotes...."
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = UIViewController()
        self.window!.rootViewController!.view = view
        self.window!.backgroundColor = UIColor.yellowColor()
        self.window!.makeKeyAndVisible()
        
        //Background fetching
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //Update the Model
    }

}

// Feature list
// - Add the new StandS4 API to the server
// - Add notification features for early morning daily quote
// - Implement notification center widget
// - Add apple watch target
// - Add a menu { allow user change the colors }
// - Add advertisements to the app
// - Create the mac version
// - Add a share feature for the quotes
// - Integrate beautiful adverts in the app
// - Allow people add their own quotes { People can upvote & downvote quotes just like stack overflow, User generated content + My generated content 🙌🏽🙌🏽🙌🏽 }
// - Apple Watch feature: Send the user a quote about hearts based on the current heartbeat


// Bugs list
// -- Fix the bug on the server side, preventing cron jobs from executing with results
// -- Allow text re-size to accomodate for long quotes
// -- Alert the user when there is no network connection
// -- server side, write a script to prevent duplicate quotes
