//
//  Quote.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 21/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

class Quote {
    
    var quote:String?
    var author:String?
    var tag:String?
    var createdAt:NSDate?
    var updatedAt:NSDate?
    
    convenience init(){
        self.init(quote:"", author:"", tag:"" )
    }
    
    init( quote:String, author:String, tag:String ){
        self.quote = quote; self.author = author; self.tag = tag;
    }
}
