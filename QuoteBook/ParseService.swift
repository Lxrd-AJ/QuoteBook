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
            if error != nil {
                print(error);
                //Try fetching quotes from local datastore
                //query = PFQuery(className: "Quote")
                query.fromLocalDatastore()
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error != nil {
                        //Use the local quotes 
                        if let objs = objects {
                            print("Using \(objs.count) objects from local store")
                            callBack(quotes: objs.map(ParseService.parseObjectToQuote) )
                        }
                    }else{
                        print("No Quotes in local store")
                        callBack(quotes: [])
                    }
                })
            }
            else{
                if let objects = objects {
                    //Save the objects in the local datastore
                    PFObject.pinAllInBackground(objects, withName: "Quotes")
                    result = objects.map( ParseService.parseObjectToQuote )
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
    
    class func parseQuoteToObject( quote:Quote ) -> PFObject {
        let object = PFObject(className: "Quote" )
        object["author"] = quote.author
        object["quote"] = quote.quote
        object["Tag"] = quote.tag
        return object;
    }
}