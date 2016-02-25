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
    var image: UIImage?
    var biography: String? //HTML String
    
    class func parseObjectToAuthor( object:PFObject ) -> Author {
        let author = Author()
        author.objectID = object.objectId!
        author.name = object["name"] as! String
        author.createdAt = object.createdAt
        author.updatedAt = object.updatedAt
        author.wikiPageTitle = object["wikiPageTitle"] as? String
        
        //MARK: WikiMedia Related Data
        if object["image"] == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                WikiService.getAuthorImage( author ).then{ image in
                    author.image = image
                }
            })
        }else{ author.image = object["image"] as? UIImage }
        
        if object["biography"] == nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                WikiService.getAuthorBiography(author).then{ biography in
                    author.biography = biography
                }
            })
        }else{ author.biography = object["biography"] as? String }
        
        if (object["image"] == nil) || (object["biography"] == nil) { author.save() }
        //END MARK: WikiMedia Related Data
        
        return author
    }

    func save() {
        let object = PFObject(className: "Author")
        object["name"] = self.name
        if self.objectID != "" { object.objectId = self.objectID }
        object["wikiPageTitle"] = self.wikiPageTitle
        object["image"] = self.image
        object["biography"] = self.biography
        object.saveInBackground()
    }
}

