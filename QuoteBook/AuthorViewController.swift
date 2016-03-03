//
//  AuthorViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 12/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCGLogger
import SnapKit

/**
 Viewing a specific author
 - note: 
    * Sometimes the author might have image and biography information but sometimes they dont show, which is why they are fetched
      again in `viewWillAppear`
 */
class AuthorViewController: UIViewController {
    
    var author: Author!

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewQuotesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesCollectionView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = author.name
        //Setup UI
        if author.image == nil {
            self.backgroundImageView.hidden = true
        }else{
            author.fetchImage()//Sometimes they still dont load
            author.fetchBiography()
            self.backgroundImageView.image = author.image
        }
        
        if let biography = author.biography {
            let webContent = "<html><head><style type=\"text/css\">body{ font-family: 'Baskerville' }</style></head><body>\(biography)</body></html>"
            self.webView.loadHTMLString(webContent, baseURL: nil)
        }else{
            //If the author has no biography, then there possibly cant be any image for the author
            self.webView.hidden = true
            self.viewQuotesButton.hidden = true
            let errorLabel = UILabel()
            self.view.addSubview(errorLabel)
            errorLabel.text = "Err It seems there is no information for \(self.author.name)"
            errorLabel.numberOfLines = 0
            errorLabel.textAlignment = .Center
            errorLabel.sizeToFit()
            errorLabel.snp_makeConstraints { make -> Void in
                make.center.equalTo(self.view.snp_center)
                make.width.lessThanOrEqualTo(self.view.snp_width)
            }
            
        }
        self.webView.addBorder(edges: [.Left,.Right], colour: getBackgroundColor(), thickness: 5.0)
        self.webView.backgroundColor = getBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showQuotesForCurrentAuthor(sender: UIButton) {
        log.info( author.name )
        if let feedVC = self.storyboard?.instantiateViewControllerWithIdentifier("FeedViewController") as? FeedViewController {
            //self.presentViewController(feedVC, animated: true, completion: nil)
            //self.navigationController?.presentViewController(feedVC, animated: true, completion: nil)
            feedVC.shouldShowGlobalQuotes = false
            feedVC.author = author
            self.navigationController?.showViewController(feedVC, sender: self)
        }
    }

}
