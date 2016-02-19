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
    
    var author: Author!

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewQuotesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = author.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setup UI
        self.backgroundImageView.image = author.image
        let webContent = "<html><head><style type=\"text/css\">body{ font-family: 'Baskerville' }</style></head><body>\(author.biography)</body></html>"
        self.webView.loadHTMLString(webContent, baseURL: nil)
        self.webView.addBorder(edges: [.Left,.Right], colour: getBackgroundColor(), thickness: 5.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showQuotesForCurrentAuthor(sender: UIButton) {}

}
