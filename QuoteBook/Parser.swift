//
//  Parser.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 02/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import SwiftyJSON

class Parser: NSObject {
    
    func createQuote( title:String, quote:String ) -> QBQuote {
        let res = QBQuote()
        res.setTitle(title, forQuote: quote)
        return res
    }

    static func parseiHeartQuotes( quote:AnyObject ) -> QBQuote {
        let json = JSON( quote )
        let quote = QBQuote()
        if let body = json["quote"].string {
            quote.setQuoteAuthor("I❤️Quote")
            quote.setTitle("Random", forQuote: body)
        }
        return quote
    }
}



