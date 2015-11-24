//
//  AppDelegate.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 21/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import Parse
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    var window:UIWindow?
    var remoteQuoteID:String?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("z3rPfifyHvVjZh2U9KsWOEQz9GOWPOYc1o8LCfDk", clientKey: "6EIPhRpX5apNxkqkeiwZ2MIJ3nR0CIBUBoSNYz51")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        self.window!.backgroundColor = getBackgroundColor()
        
        //Notifications checking
        if let localNotification:UILocalNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            application.applicationIconBadgeNumber = localNotification.applicationIconBadgeNumber--
        }
        if let remoteNotificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            print("Remote Notification Payload \(remoteNotificationPayload)")
            remoteQuoteID = remoteNotificationPayload["objectID"] as? String
        }
        
        //Background fetching
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        
        //Configure a Session for interacting with the watch app to send Application context
        updateSessionContext()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //Save the deviceToken in the current installation and save it to Parse
        let currentInstallation:PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == .Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        //Set the remoteQuoteID to the objectID of the new quote just added on the server
        if let objectID:String = userInfo["objectID"] as? String {
            remoteQuoteID = objectID
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //Update the Model
        ParseService.fetchQuotes({ (quotes:[Quote]) -> Void in
            self.updateSessionContext()
            completionHandler( UIBackgroundFetchResult.NewData )
        })
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        updateSessionContext()
    }
    
    //attaches to the current WCSession and updates the application context on the watch
    func updateSessionContext(){
        if WCSession.isSupported() {
            let session:WCSession = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            NSKeyedArchiver.setClassName("Quote", forClass: Quote.self )
            NSKeyedArchiver.setClassName("WatchData", forClass: WatchData.self )
            
            //Send Application context data to the watch
            updateApplicationContextToExtensions(session)
            
        }else{ print("Sessions not supported on iOS app") }
    }
    
    func updateApplicationContextToExtensions( session:WCSession ){
        ParseService.fetchQuotes({ (var quotes:[Quote]) -> Void in
            quotes.sortInPlace({ $0.createdAt!.compare($1.createdAt!) == .OrderedDescending })            
            let data:WatchData = WatchData( quotes:Array(quotes[0..<10]) )
            let payload = NSKeyedArchiver.archivedDataWithRootObject(data)
            do { try session.updateApplicationContext(["appContext":payload]); }
            catch{ print(error) }
        })

    }

}
