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

@objc enum DownloadStatus:Int {
    case Idle
    case Downloading
    case FinishedDownloading
    case NewQuotes
    case NoQuote
    case NetworkError
}
//TODO: The network adapter should be used in the model instead

@objc protocol NetworkAdapterDelegate {
    func clientDidFinishDownloading( sender:NSObject, data:NSString, status:DownloadStatus )
}

class NetworkAdapter: NSObject {
    let iheartQuotes = "http://www.iheartquotes.com/api/v1/random?format=text"
    var status:DownloadStatus = .Idle
    var randomQuote:NSString?
    var delegate:NetworkAdapterDelegate?
    
    func getRequest( url:String? ) {
        let HTTPMethod = "GET"
        let timeout = 100
        let URL = NSURL( string: iheartQuotes )
        let URLRequest = NSMutableURLRequest(URL: URL!)
        URLRequest.HTTPMethod = HTTPMethod
        let queue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(URLRequest, queue: queue, completionHandler: {
            (response:NSURLResponse!, data:NSData?, error:NSError! ) in
            if data?.length > 0 && error == nil {
                let result = NSString( data: data! , encoding: NSUTF8StringEncoding )
                self.status = .NewQuotes
                self.randomQuote = result
                self.delegate?.clientDidFinishDownloading(self, data: result!, status: .NewQuotes )
                println( result! )
            }else{
                println( error )
                self.delegate?.clientDidFinishDownloading(self, data: NSString(), status: .NetworkError )
            }
        })
        
    }
    
}