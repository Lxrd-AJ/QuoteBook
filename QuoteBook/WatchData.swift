//
//  WatchData.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 10/11/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

class WatchData: NSObject, NSCoding {
    
    var quotes:[Quote]!
    
    convenience init( quotes:[Quote] ){
        self.init()
        self.quotes = quotes;
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.quotes = aDecoder.decodeObjectForKey("quotes") as! [Quote]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(quotes, forKey: "quotes")
    }
}