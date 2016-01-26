//
//  AuthorViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 12/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuthorViewController: UIViewController {
    
    var json:JSON?
    var backgroundImage: UIImage? //TODO: Remove later when you are using a WikiService class
    var author: Author!

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewQuotesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = author.name
        //print(json)
        
        //imagesCollectionView.hidden = true
        //viewQuotesButton.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setup UI
        if let img = backgroundImage {
            self.backgroundImageView.image = img
        }else{ self.backgroundImageView.hidden = true }
        if json != nil { setupViewWithJSON(json!) }
        else{ print("View is nill") }
        
        //Setup Images
        if let imgs = json!["images"].array {
            print(imgs)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showQuotesForCurrentAuthor(sender: UIButton) {
    }

    func setupViewWithJSON( json:JSON ){
        let webContent = "<html><head><style type=\"text/css\">body{ font-family: 'Baskerville' }</style></head><body>\(json["extract"].string!)</body></html>"
        self.webView.loadHTMLString(webContent, baseURL: nil)
        self.webView.addBorder(edges: [.Left,.Right], colour: getBackgroundColor(), thickness: 5.0)
        
    }

}
