//
//  Author.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 03/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import Foundation
import Parse

class Author {
    var name: String = ""
    var objectID: String = ""
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var wikiPageTitle: String?
    
    class func parseObjectToAuthor( object:PFObject ) -> Author {
        let author = Author()
        author.objectID = object.objectId!
        author.name = object["name"] as! String
        author.createdAt = object.createdAt
        author.updatedAt = object.updatedAt
        author.wikiPageTitle = object["wikiPageTitle"] as? String
        return author
    }
}