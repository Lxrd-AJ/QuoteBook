//
//  Quote.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 21/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

class Quote:NSObject, NSCoding {
    
    var quote:String?
    var author:String?
    var tag:String?
    var createdAt:NSDate?
    var updatedAt:NSDate?
    
    convenience override init(){
        self.init(quote:"", author:"", tag:"" )
    }
    
    @objc required convenience init( coder decoder:NSCoder ){
        self.init()
        self.quote = decoder.decodeObjectForKey("quote") as? String
        self.author = decoder.decodeObjectForKey("author") as? String
        self.tag = decoder.decodeObjectForKey("tag") as? String
        self.createdAt = decoder.decodeObjectForKey("createdAt") as? NSDate
        self.updatedAt = decoder.decodeObjectForKey("updatedAt") as? NSDate
    }
    
    init( quote:String, author:String, tag:String ){
        self.quote = quote; self.author = author; self.tag = tag;
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        if let quote = quote { aCoder.encodeObject(quote, forKey: "quote") }
        if let author = author { aCoder.encodeObject(author, forKey: "author") }
        if let tag = author { aCoder.encodeObject(tag, forKey: "tag") }
        if let createdAt = createdAt { aCoder.encodeObject(createdAt, forKey: "createdAt") }
        if let updatedAt = updatedAt { aCoder.encodeObject(updatedAt, forKey: "updatedAt") }
    }
}
