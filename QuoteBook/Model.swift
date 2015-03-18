//
//  Model.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

@objc protocol ModelDelegate {
    func didFinishDownloadingData( #sender:NSObject )
}

class Model: NSObject {
    
    var downloadedQuotes:[QBQuote] = []
    var delegate:ModelDelegate?
    var counter:Int = 0
    let networkClient:NetworkAdapter = NetworkAdapter()
    
    override init() {
        //begin downloads
        super.init()
        networkClient.delegate = self
        //networkClient.getRequest("")
        networkClient.downloadQuotesFromAPIs()
    }
    
    func quoteCount() -> Int {
        return self.downloadedQuotes.count
    }
    
    func nextQuote() -> QBQuote {
        counter = counter++ % quoteCount()
        return self.downloadedQuotes[counter]
    }
    
    func previousQuote() -> QBQuote {
        counter = counter-- % quoteCount()
        return self.downloadedQuotes[counter]
    }
    
}

extension Model: NetworkAdapterDelegate {
    func clientDidFinishDownloading(sender: NSObject, data: AnyObject?, status: DownloadStatus) {
        switch status {
        case .NewQuotes:
            counter = -1
            let quote = Parser.parseiHeartQuotes(data!)
            self.downloadedQuotes.append(quote)
            self.delegate?.didFinishDownloadingData( sender: self )
        default:
            println("No new quotes")
        }
        
    }
}