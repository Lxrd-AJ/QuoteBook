//
//  AuthorsCollectionViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 03/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

//Get Author Info with images => https://en.wikipedia.org/w/api.php?action=query&titles=Albert%20Einstein&prop=extracts|images|info&format=json&exintro=1
// https://en.wikipedia.org/w/api.php?action=query&titles=Alexander%20Pope&prop=extracts|images|info|imageinfo&format=json&exintro=1

//Getting Image Data => https://en.wikipedia.org/w/api.php?action=query&titles=File:Albert Einstein's exam of maturity grades (color2).jpg&prop=imageinfo&iiprop=url

import UIKit
import SwiftSpinner

private let reuseIdentifier = "AuthorCell"

class AuthorsCollectionViewController: UICollectionViewController {
    
    var authors: [Author] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading", animated: true)
        //Fetch the authors
        ParseService.getAllAuthors({ (authors:[Author]) -> Void in
            self.authors = authors
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
        
        cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.5)
        cell.layer.cornerRadius = 5.0
        cell.authorNameLabel.text = author.name
        cell.authorNameLabel.sizeToFit()
    
        return cell
    }

}
