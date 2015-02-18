//
//  NetworkAdapter.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/02/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

class NetworkAdapter: NSObject {
    let name:NSString?
    var quote:QBQuote = QBQuote()
    
    override init() {
        name = "Me"
        super.init()
        
    }
}