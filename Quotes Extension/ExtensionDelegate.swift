//
//  ExtensionDelegate.swift
//  Quotes Extension
//
//  Created by AJ Ibraheem on 29/10/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    var quotes:[Quote]?

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
        //Configure a Session
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

}

extension ExtensionDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        print(userInfo)
        if let quotes = userInfo["Quotes"] as? [Quote] {
            print("Unwrapped => \(quotes)")
            self.quotes = quotes
        }
    }
}