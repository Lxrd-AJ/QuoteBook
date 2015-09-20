//
//  NetworkAdapter.swift
//  QuoteBook
//
//
//  Created by AJ Ibraheem on 18/02/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation
//import Alamofire
import Parse

@objc enum DownloadStatus:Int {
    case Idle
    case Downloading
    case FinishedDownloading
    case NewQuotes
    case NoQuote
    case NetworkError
    case MoreQuotes
}

@objc protocol NetworkAdapterDelegate {
    func clientDidFinishDownloading( sender:NSObject, data:[String:AnyObject], status:DownloadStatus )
    func didFinishDownloading( data:[QBQuote] )
    func didFinishBackgroundFetch( data:[QBQuote] )
}

class NetworkAdapter: NSObject {

    var status:DownloadStatus = .Idle
    var randomQuote:NSString?
    var delegate:NetworkAdapterDelegate?
    let iheartQuotes = "http://www.iheartquotes.com/api/v1/random"
    let api = [
            "iHeartQuote": "http://www.iheartquotes.com/api/v1/random",
            "theySaidSo": "http://api.theysaidso.com/qod.json"
        ]
    
//    func downloadQuotesFromAPIs() {
//        Alamofire.request( .GET, iheartQuotes, parameters:["format":"json", "max_lines":"10", "max_characters":"65"] ).responseJSON(options: .MutableContainers){
//            (request, response, json, error) in
//            if error == nil {
//                self.delegate?.clientDidFinishDownloading(self, data: ["iHeartQuote":json!], status: .NewQuotes )
//                //println( json )
//            }else{
//                println( error )
//            }
//        }
//        downloadQuotes()
//    }
//    
//    func downloadQuotes(){
//        for (key,value) in api {
//            Alamofire.request( .GET, value ).responseJSON(options: .MutableContainers, completionHandler: {
//                (request, response, json, error ) in
//                if error == nil {
//                    println( json! )
//                    self.delegate?.clientDidFinishDownloading(self, data:[ key: json! ], status: .MoreQuotes )
//                }
//            })
//        }
//    }
//    
    func downloadQuotesFromServer(){
        var quotes = Array<QBQuote>()
        let query = PFQuery( className: "Quote" )
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error: NSError?) -> Void in
            if let objects = objects as? [PFObject] {
                for object in objects {
                    let obj = Parser.parsePFObjectToQuote( object )
                    quotes.append( obj )
                }
                self.delegate?.didFinishDownloading(quotes)
            }
        }
    }
    
    func fetchQuotesInBackground( callBack:(fetchStatus:UIBackgroundFetchResult) -> Void ) {
        var quotes = Array<QBQuote>()
        let query = PFQuery( className: "Quote" )
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
    }
    
}