//
//  NetworkAdapter.swift
//  QuoteBook
//
//
//  Created by AJ Ibraheem on 18/02/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

@objc enum DownloadStatus:Int {
    case Idle
    case Downloading
    case FinishedDownloading
    case NewQuotes
    case NoQuote
    case NetworkError
}

@objc protocol NetworkAdapterDelegate {
    func clientDidFinishDownloading( sender:NSObject, data:AnyObject?, status:DownloadStatus )
}

class NetworkAdapter: NSObject {
    let iheartQuotes = "http://www.iheartquotes.com/api/v1/random"
    var status:DownloadStatus = .Idle
    var randomQuote:NSString?
    var delegate:NetworkAdapterDelegate?
    let api = [
            "iHeartQuote": "http://www.iheartquotes.com/api/v1/random",
            "theySaidSo": "http://api.theysaidso.com/qod.json"
        ]
    
    func downloadQuotesFromAPIs() {
        Alamofire.request( .GET, iheartQuotes, parameters:["format":"json", "max_lines":"3", "max_characters":"50"] ).responseJSON(options: .MutableContainers){
            (request, response, json, error) in
            if error == nil {
                self.delegate?.clientDidFinishDownloading(self, data: json!, status: .NewQuotes )
                println( json )
            }else{
                println( error )
                self.delegate?.clientDidFinishDownloading(self, data: json, status: .NetworkError )
            }
        }
    }
    
}