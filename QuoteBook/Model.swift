//
//  Model.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation



@objc protocol ModelDelegate {
    func didFinishDownloadingData( sender sender:NSObject )
    func didFinishBackgroundFetch( sender sender:Model )
}


class Model: NSObject {
    
//    var downloadedQuotes:[QBQuote] = []
//    var delegate:ModelDelegate?
//    var counter:Int = 0
//    let networkClient:NetworkAdapter = NetworkAdapter()
//    
//    override init() {
//        //begin downloads
//        super.init()
//        networkClient.delegate = self
//        //networkClient.downloadQuotesFromAPIs()
//        //networkClient.downloadQuotesFromServer()
//    }
//    
//    func quoteCount() -> Int {
//        return self.downloadedQuotes.count
//    }
//    
//    func nextQuote() -> QBQuote? {
//        return self.downloadedQuotes[ counter++ % quoteCount() ]
//    }
//    
//    func previousQuote() -> QBQuote? {
//        return self.downloadedQuotes[ counter-- % quoteCount() ]
//    }
//    
}

//extension Model: NetworkAdapterDelegate {
    //func clientDidFinishDownloading(sender: NSObject, data: [String:AnyObject], status: DownloadStatus) {
//        switch status {
//        case .NewQuotes:
//            counter = -1
////            let quote = Parser.parseiHeartQuotes(data)
////            self.downloadedQuotes.append(quote)
////            self.delegate?.didFinishDownloadingData( sender: self )
////        case .MoreQuotes:
////            self.downloadedQuotes.append( Parser.parseQuote( data ) )
////        default:
////            self.delegate?.didFinishDownloadingData(sender: self)
////            println("No new quotes")
////        }
//    }
//    
//    func didFinishDownloading(data: [QBQuote]) {
//        self.downloadedQuotes = data
//        self.downloadedQuotes.shuffle()
//        self.delegate?.didFinishDownloadingData( sender: self )
//    }
//    
//    func didFinishBackgroundFetch( data:[QBQuote] ) {
//        self.downloadedQuotes = data
//        self.downloadedQuotes.shuffle()
//        self.delegate?.didFinishBackgroundFetch(sender: self)
//    }
//}