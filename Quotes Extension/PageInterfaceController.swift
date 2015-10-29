//
//  PageInterfaceController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 29/10/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

//RULE: There are only the top 10 quotes on the apple watch target

class PageInterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

//        if let delegate:ExtensionDelegate = WKExtension.sharedExtension().delegate as? ExtensionDelegate{
//            if let quotes = delegate.quotes {
//                let identifiers:[String] = quotes.map({ _ in return "QuoteController" })
//                WKInterfaceController.reloadRootControllersWithNames(identifiers , contexts: quotes)
//            }
//        }
        
        //Configure a Session
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            print("Watch Configured a session")
            print("Watch is Sending a request for quotes")
            _ = WCSession.defaultSession().transferUserInfo(["Test":1])
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension PageInterfaceController: WCSessionDelegate {
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        print(userInfo)
        if let quotes = userInfo["Quotes"] as? [Quote] {
            print("Watch Unwrapped => \(quotes)")
            let identifiers:[String] = quotes.map({ _ in return "QuoteController" })
            WKInterfaceController.reloadRootControllersWithNames(identifiers , contexts: quotes)
        }
    }
}
