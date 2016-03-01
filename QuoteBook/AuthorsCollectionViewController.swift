//
//  AuthorsCollectionViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 03/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//


import UIKit
import SwiftSpinner
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "AuthorCell"

/**
 - todo:
    * Show an error message wand stop spinning if there is no internet connection
 */
class AuthorsCollectionViewController: UICollectionViewController {
    
    var authors: [Author] = []
    let imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading", animated: true)
        //Fetch the authors
        ParseService.getAllAuthors({ (authors:[Author]) -> Void in
            self.authors = authors
            //TODO: Hack! - Try getting the authors from the current quotes too and adding them here
            self.collectionView?.reloadData()
            SwiftSpinner.hide()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Authors"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAuthorViewController" ,let indexPath = self.collectionView?.indexPathsForSelectedItems()?.first {
            let authorViewController: AuthorViewController = segue.destinationViewController as! AuthorViewController
            let author = self.authors[ indexPath.item ]
            authorViewController.author = author;
        }
    }

    //UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return authors.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AuthorCell
        let author = self.authors[ indexPath.item ]
        
        //Prefetch images/biography if necessary
        author.fetchBiography()
        author.fetchImage()
        
        cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.5)
        cell.layer.cornerRadius = 5.0
        cell.authorNameLabel.text = author.name
        cell.authorNameLabel.sizeToFit()
        //cell.authorImageView.image = nil
        cell.quotesCountLabel.hidden = true
        cell.authorImageView.image = author.image
        
        return cell
    }

}
