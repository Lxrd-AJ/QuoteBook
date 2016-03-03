//
//  Parse.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 20/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.

import Foundation
import Parse
import PromiseKit

class ParseService {
    class func fetchQuotes( callBack:(quotes:[Quote]) -> Void ) -> [Quote]? {
        let query = PFQuery( className: "Quote" )
        query.limit = 50
        query.orderByDescending("createdAt");
        var result:[Quote]?
        query.findObjectsInBackgroundWithBlock({(objects:[PFObject]?,error:NSError?) -> Void in
            if error != nil {
                print(error);
                //Try fetching quotes from local datastore
                query.fromLocalDatastore()
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
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
    
    class func getAllAuthors( callBack:(authors:[Author]) -> Void ){
        let query = PFQuery( className: "Author" )
        query.orderByDescending("createdAt");
        query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?,error:NSError?) -> Void in
            if error == nil {
                if let objs = objects {
                    callBack(authors: objs.map(Author.parseObjectToAuthor))
                }
            }else{ callBack(authors: []) }
        })
    }
    
    /**
     Returns a promise that resolves to the quotes for the specified author or nil if not founf
     */
    class func getQuotesForAuthor( author:Author ) -> Promise<[Quote]?> {
        let query = PFQuery(className: "Quote")
        query.whereKey("author", equalTo: author.name)
        return Promise{ fulfill, reject in
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        let quotes = objects.map( ParseService.parseObjectToQuote )
                        fulfill(quotes)
                    }
                }else{ fulfill(nil) }
            })
        }
    }
    
    

    //TODO: Move to Quote Class instead
    class func parseObjectToQuote( object:PFObject ) -> Quote {
        let result = Quote();
        result.author = object["author"] as? String
        result.createdAt = object.createdAt
        result.quote = object["quote"] as? String
        result.tag = object["Tag"] as? String
        result.updatedAt = object.updatedAt
        return result;
    }
    //TODO: Move to Quote Class instead
    class func parseQuoteToObject( quote:Quote ) -> PFObject {
        let object = PFObject(className: "Quote" )
        object["author"] = quote.author
        object["quote"] = quote.quote
        object["Tag"] = quote.tag
        return object;
    }
}