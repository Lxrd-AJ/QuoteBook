//
//  Parse.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 20/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation
import Parse

class ParseService {
    class func fetchQuotes( callBack:(quotes:[Quote]) -> Void ) -> [Quote]? {
        let query = PFQuery( className: "Quote" )
        var result:[Quote]?
        query.findObjectsInBackgroundWithBlock({(objects:[PFObject]?,error:NSError?) -> Void in
            if error != nil { print(error); callBack(quotes: []) }
            else{
                if let objects = objects {
                    result = objects.map( ParseService.parseObjectToQuote )
                    print("Done fetching quotes from Server")
                    callBack(quotes: result!)
                }
            }
            
        });
        return result;
    }

    class func parseObjectToQuote( object:PFObject ) -> Quote {
        let result = Quote();
        result.author = object["author"] as? String
        result.createdAt = object.createdAt
        result.quote = object["quote"] as? String
        result.tag = object["Tag"] as? String
        result.updatedAt = object.updatedAt
        return result;
    }
}