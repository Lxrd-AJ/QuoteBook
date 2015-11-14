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

class PageInterfaceController: WKInterfaceController,WCSessionDelegate {
    
    @IBOutlet var textLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        textLabel.setText("Patience is a Virtue, Updating your quotes ....")
        
        //Configure a Session
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()

            NSKeyedUnarchiver.setClass(Quote.self , forClassName: "Quote" )
            NSKeyedUnarchiver.setClass(WatchData.self , forClassName: "WatchData")
            
            if let data = session.receivedApplicationContext["appContext"] as? NSData {
                if let watchData:WatchData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? WatchData{
                    let quotes:[Quote] = watchData.quotes
                    let identifiers:[String] = quotes.map({ _ in return "QuoteController" })
                    WKInterfaceController.reloadRootControllersWithNames(identifiers , contexts: quotes)
                }else{
                    //Failed to decode data 
                    textLabel.setText("Please restart the application, An error occurred whilst decoding the data")
                    print("Failed to decode WatchData")
                }
                
            }else{
                //No application context information available
                textLabel.setText("It seems there are no Quotes on the watch, try launching the companion iOS app")
                print("No Context information on watch, try launching iOS application first")
            }
        }else{
            print("Couldn't configure a watch Session")
            textLabel.setText("An error occurred while fetching your quotes, try launching the companion app")
        }
        
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}

