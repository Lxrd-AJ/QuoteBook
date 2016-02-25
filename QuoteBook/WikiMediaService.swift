//
//  WikiMediaService.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 24/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

//Get Author Info with images => https://en.wikipedia.org/w/api.php?action=query&titles=Albert%20Einstein&prop=extracts|images|info&format=json&exintro=1
// https://en.wikipedia.org/w/api.php?action=query&titles=Alexander%20Pope&prop=extracts|images|info|imageinfo&format=json&exintro=1

//Getting Image Data => https://en.wikipedia.org/w/api.php?action=query&titles=File:Albert Einstein's exam of maturity grades (color2).jpg&prop=imageinfo&iiprop=url

extension Alamofire.Request {
    public static func imageResponseSerializer() -> ResponseSerializer<UIImage,NSError> {
        return ResponseSerializer{ request, response, data, error in
            guard (data != nil || (error == nil)) else { return .Failure(error!) }
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            return .Success(image!)
        }
    }
    
    public func responseImage( completionHandler:Response<UIImage,NSError> -> Void ) -> Self {
        return response(responseSerializer: Request.imageResponseSerializer(), completionHandler: completionHandler)
    }
}

/**
 Handles all WikiPedia related services, provides the following functionality
    * Getting the image of an author
    * Getting the Biography of an author
 
 - todo:
    1. Get the author Biography
    2. Get the author image
 */
struct WikiService {
    
    static let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    private enum Router: URLRequestConvertible {
        static let wikiAuthorUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts|images|info&format=json&exintro=1"
        static let wikiImgUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=imageinfo&iiprop=url&format=json"
        
        case Author(String)
        case Image(String)
        
        var URLRequest: NSMutableURLRequest {
            let result: (url:String, parameters:[String:AnyObject]) = {
                switch self {
                case .Author(let name):
                    return ( Router.wikiAuthorUrl,["titles":name] )
                case .Image(let imageName):
                    return ( Router.wikiImgUrl, ["titles":imageName] )
                }
            }()
            
            let URL = NSURL(string: result.url)
            let URLRequest = NSURLRequest(URL: URL!)
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
    
    /**
    - todo:
        - Recieve as parameters only the attributes you need and not the entire author object
        - Handle all errors in each promise section
    - warning:
        Unsafe method, do not call yet
    */
    static func getAuthorImage( author:Author ) -> Promise<UIImage?> {
        return WikiService.getAuthorJSON( author.name ).then( on: WikiService.queue ){ (json:JSON?) -> Promise<UIImage?> in
            if let json = json where json["images"].isExists() {
                if let imgTitle = WikiService.getImageTitleFromWikiJSON( json["images"].array! ){
                    return getUIImage( imgTitle )
                }
            }
            throw Error.errorWithCode(0, failureReason: "abc")
        }
    }
    
    /**
     - todo:
        - Recieve as parameters only the attributes you need and not the entire author object
     */
    static func getAuthorBiography( author:Author ) -> Promise<String?> {
        return WikiService.getAuthorJSON( author.name ).then{ (json:JSON?) -> Promise<String?> in
            return Promise{ fulfill, reject in
                guard json != nil else{ fulfill(nil); return; }
                if !json!["query"]["pages"]["-1"].isExists() { //if the author exists in wiki
                    //Get the author extract
                    if let index:[String:JSON] = json!["query"]["pages"].dictionary where index.first != nil  {
                        let authorJSON = index.first!.1
                        fulfill(authorJSON["extract"].string!)
                    }
                }
            }
        }
    }
    
    /**
     - warning: Do not call yet, as error handling not yet implemented
     */
    private static func getUIImage( imageName:String ) -> Promise<UIImage?> {
        return Promise{ fulfill,reject in
            //Get the image information
            Alamofire.request( Router.Image(imageName) ).responseJSON(completionHandler: { response in
                switch response.result {
                case .Success(let result):
                    let json = JSON( result )
                    if let imgURL = json["query"]["pages"]["-1"]["imageinfo"][0]["url"].string { fulfill(imgURL) }
                    else{ reject(result.error!!) } //TODO: Fail Gracefully here
                case .Failure(let err):
                    print(err)
                    reject(err)
                }
            })
        }.then{ (imgURL:String) -> Promise<UIImage?> in
            //fulfill the returned promise with a UIImage
            return Promise{ fulfill,reject in
                Alamofire.request( .GET, imgURL ).responseImage({ response in
                    switch response.result {
                    case .Success( let image):
                        fulfill(image)
                    case .Failure( _):
                        fulfill(nil)
                    }
                })
            }//end Promise
        }
    }
    
    private static func getImageTitleFromWikiJSON( wikiJSON:[JSON] ) -> String? {
        return wikiJSON.filter({ (json:JSON) in
            if let title = json["title"].string {
                let split = title.characters.split{ $0 == "." }.map(String.init).last
                return split?.rangeOfString("jpg|png|JPG|PNG",options: .RegularExpressionSearch) != nil
            }else{ return false }
        }).first?["title"].string
    }
    
    private static func getAuthorJSON( authorName:String ) -> Promise<JSON?> {
        return Promise { fulfill, reject in
            Alamofire.request(Router.Author(authorName)).responseJSON(completionHandler:{ response in
                if response.result.error != nil, let error = response.result.error { reject(error) }
                else if let data = response.result.value { fulfill( JSON(data) ) }
                else{ reject( NSError(domain: "abc", code: 0, userInfo: nil) ) }
            })
        }
    }
}

//TODO: Cache the JSON Response
//TODO: Use Grand Central Dispatch when making the network request
//cell.request = Alamofire.request( .GET, wikiAuthorUrl, parameters:["titles":author.name]).responseJSON(completionHandler: { response in
//    if let requestValue = response.result.value {
//        if let json = self.parseWikiResponseJSON( JSON(requestValue) ) {
//            cell.json = json
//            //Get the 1st JPEG image url
//            if json["images"].isExists() {
//                if let imageName = self.getImageTitleFromWikiJSON(json["images"].array!) {
//                    //Get the Image Data JSON
//                    let wikiImgUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=imageinfo&iiprop=url&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//                    let encodingKey = response.request!.URLString
//                    if let image = self.imageCache.objectForKey(encodingKey) as? UIImage {
//                        cell.authorImageView.image = image
//                    }else{
//                        Alamofire.request( .GET, wikiImgUrl, parameters:["titles":imageName]).responseJSON { response in
//                            switch response.result {
//                            case .Success:
//                                if let value = response.result.value {
//                                    let json = JSON(value)
//                                    if let imgUrl = json["query"]["pages"]["-1"]["imageinfo"][0]["url"].string {
//                                        Alamofire.request( .GET, imgUrl ).response { (request,response,data,error) in
//                                            if let data = data {
//                                                let image = UIImage(data: data, scale: 1)
//                                                cell.authorImageView.image = image
//                                                self.imageCache.setObject(image!, forKey: encodingKey)
//                                            }
//                                        }
//                                    }
//                                }
//                            case .Failure(let error):
//                                print(error)
//                            }
//                        }//end requeest
//                    }//end else
//                }
//            }
//        }
//    }
//})