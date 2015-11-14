//
//  GlanceController.swift
//  Quotes Extension
//
//  Created by AJ Ibraheem on 29/10/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class GlanceController: WKInterfaceController, WCSessionDelegate {
    
    var glanceQuote:Quote?
    @IBOutlet var authorLabel: WKInterfaceLabel!
    @IBOutlet var quoteLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
     
        //Configure a Session
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            NSKeyedUnarchiver.setClass(Quote.self , forClassName: "Quote" )
            NSKeyedUnarchiver.setClass(WatchData.self , forClassName: "WatchData")
            
            if let data = session.receivedApplicationContext["appContext"] as? NSData {
                if let watchData:WatchData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? WatchData{
                    glanceQuote = watchData.quotes.first
                    //get the first quote with short text
                    glanceQuote = watchData.quotes.filter({ $0.quote?.characters.count < 100 }).first
                }
            }
        }else{ print("Session not available in GlanceController") }

    }

    override func willActivate() {
        super.willActivate()
        //Update the user interface
        if let glanceQuote = glanceQuote {
            authorLabel.setText( glanceQuote.author )
            quoteLabel.setText( glanceQuote.quote )
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
