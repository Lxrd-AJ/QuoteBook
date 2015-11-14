//
//  QuoteController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 29/10/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import WatchKit
import Foundation


class QuoteController: WKInterfaceController {
    
    var quote:Quote!
    @IBOutlet var authorLabel: WKInterfaceLabel!
    @IBOutlet var quoteLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        quote = context! as! Quote
        
    }

    override func willActivate() {
        super.willActivate()
        //Instantiate the view
        authorLabel.setText( quote.author )
        quoteLabel.setText( quote.quote )
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
