//
//  Author.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 03/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import Foundation
import Parse
import PromiseKit

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
        //Fetch the image data from Parse
        if let imageFile = object["image"] as? PFFile{
            imageFile.getDataInBackgroundWithBlock({ (data:NSData?,error:NSError?) -> Void in
                if let data = data{ author.image = UIImage(data: data) }
            })
        }
        author.biography = object["biography"] as? String
        
        return author
    }
    
    func fetchBiography(){
        if biography == nil { //Avoid unnessary requests to wikiPedia
            when( WikiService.getAuthorBiography(self) ).then{ biography in
                self.biography = biography.first!
            }.always{
                    log.info("Saving Biography for \(self.name)")
                    self.save()
            }.error{ err in print(err) }
        }else{ print("Not fetching Bio"); return; }
        
    }
    
    func fetchImage() {
        if image == nil { //Avoid unnessary requests to wikiPedia
            when( WikiService.getAuthorImage(self) ).then{ image in
                self.image = image.first!
            }.always{ self.save()
            }.error{ err in
                    print("An Error occured while fetching the user image")
                    print(err)
            }
            log.info("Fetched \(self.name)'s image => \(self.image)")
        }else{ print("Not fetching Image"); return; }
    }

    func save() {
        let saveQuery = PFQuery(className: "Author")
        saveQuery.getObjectInBackgroundWithId( self.objectID ){ (object:PFObject?, error:NSError?) -> Void in
            if error != nil { print("Failed to save object") }
            else if let object = object {
                log.info(".....saving details for \(self.name)")
                object["name"] = self.name
                object["wikiPageTitle"] = self.wikiPageTitle
                if let image = self.image {
                    object["image"] = PFFile(name: "\(self.name).jpg", data: UIImageJPEGRepresentation(image, 0.0)!)
                }
                object["biography"] = self.biography
//                object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                    if success { log.info("Successfully saved \(self.name)") }
//                    else{ log.severe("\(error)") }
//                })
                do {
                    try object.save()
                }catch{
                    print("Failed to save")
                }
            }
        }
    }
}

