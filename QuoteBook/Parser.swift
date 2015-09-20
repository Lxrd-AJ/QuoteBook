//
//  Parser.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 02/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import Parse
//import SwiftyJSON

class Parser: NSObject {

//    static func parseQuote( data: [String:AnyObject] ) -> QBQuote {
//        var result = QBQuote()
//        for (source,quote) in data{
//            switch source {
//            case "iHeartQuotes":
//                result = parseiHeartQuotes( [source:quote] )
//            default:
//                result = QBQuote()
//            }
//        }
//        return result
//    }
//    
//    static func parseiHeartQuotes( data :[String:AnyObject] ) -> QBQuote {
//        let quote = QBQuote()
//        for (key,value) in data {
//            let json = JSON( value )
//            if let body = json["quote"].string {
//                if let source = json["source"].string {
//                    quote.setQuoteAuthor("I❤️Quote")
//                    quote.setTitle("Random", forQuote: "\(body) \n - \(source)")
//                }
//            }
//        }
//        return quote
//    }
//    
//    static func parseTheySaidSo( data: [String:AnyObject] ) -> QBQuote {
//        let quote = QBQuote()
//        for (key,value) in data {
//            let json = JSON( value )
//            if let author = json["contents"]["author"].string {
//                if let quoteString = json["contents"]["quote"].string {
//                    quote.setQuoteAuthor( author )
//                    quote.setTitle("TheySaidSo", forQuote: quoteString )
//                }
//            }
//        }
//        return quote
//    }
    
    static func parsePFObjectToQuote( object:PFObject ) -> QBQuote {
        let result = QBQuote()
        let author = object["author"] as! String
        let quote = object["quote"] as! String
        result.setTitle( author, forQuote: quote )
        result.setQuoteAuthor(author)
        return result
    }
}



