//
//  Parse.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 20/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

class ParseService {
//    class func downloadQuotesFromServer(){
//        var quotes = Array<QBQuote>()
//        let query = PFQuery( className: "Quote" )
//        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
//            if let objects = objects as? [PFObject] {
//                for object in objects {
//                    let obj = Parser.parsePFObjectToQuote( object )
//                    quotes.append( obj )
//                }
//                self.delegate?.didFinishDownloading(quotes)
//            }
//        }
//    }
//    
//    class func fetchQuotesInBackground( callBack:(fetchStatus:UIBackgroundFetchResult) -> Void ) {
//        var quotes = Array<QBQuote>()
//        let query = PFQuery( className: "Quote" )
//        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
//            if let objects = objects as? [PFObject] {
//                for object in objects {
//                    let obj = Parser.parsePFObjectToQuote( object )
//                    quotes.append( obj )
//                }
//                self.delegate?.didFinishBackgroundFetch(quotes)
//                print("Background fetching \(quotes)")
//                callBack( fetchStatus: .NewData )
//            }else{
//                //No data
//                callBack( fetchStatus: .Failed )
//            }
//        }
//    }
}