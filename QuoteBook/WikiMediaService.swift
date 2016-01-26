//
//  WikiMediaService.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 24/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import Foundation
import Alamofire

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

struct WikiService {
    
    enum Router: URLRequestConvertible {
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
    
    //TODO: Create a WikiMediaService 
}