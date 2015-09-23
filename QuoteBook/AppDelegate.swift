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
        
        self.window!.backgroundColor = UIColor.yellowColor()
        
        //Background fetching
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //Update the Model
    }

}

