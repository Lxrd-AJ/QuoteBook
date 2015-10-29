//
//  ColorCollectionViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 24/10/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ColorCollectionViewController: UICollectionViewController {
    
    let colors:[Color] = [
        Color( color: UIColor(red: 210/255, green: 77/255, blue: 87/255, alpha: 1), name:"Chestnut Rose" ),
        Color( color: UIColor(red: 217/255, green: 30/255, blue: 24/255, alpha: 1), name:"ThunderBird" ),
        Color( color: UIColor(red: 239/255, green: 72/255, blue: 54/255, alpha: 1), name:"Flamingo" ),
        Color( color: UIColor(red: 219/255, green: 10/255, blue: 91/255, alpha: 1), name:"RazzMatazz" ),
        Color( color: UIColor(red: 241/255, green: 169/255, blue: 160/255, alpha: 1), name:"Wax Flower" ),
        Color(color: UIColor(red: 224/255, green: 130/255, blue: 131/255, alpha: 1), name: "NewYork Pink"),
        Color(color: UIColor(red: 220/255, green: 198/255, blue: 224/255, alpha: 1), name: "Snuff"),
        Color(color: UIColor(red: 103/255, green: 65/255, blue: 114/255, alpha: 1), name: "Honey Flower"),
        Color(color: UIColor(red: 145/255, green: 61/255, blue: 136/255, alpha: 1), name: "Plum"),
        Color(color: UIColor(red: 68/255, green: 108/255, blue: 179/255, alpha: 1), name: "San Marino"),
        Color(color: UIColor(red: 65/255, green: 131/255, blue: 215/255, alpha: 1), name: "Royal Blue"),
        Color(color: UIColor(red: 129/255, green: 207/255, blue: 224/255, alpha: 1), name: "Spray"),
        Color(color: UIColor(red: 78/255, green: 205/255, blue: 196/255, alpha: 1), name: "Medium Turquoise"),
        Color(color: UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1), name: "Gossip"),
        Color(color: UIColor(red: 38/255, green: 168/255, blue: 91/255, alpha: 1), name: "Eucalyptus"),
        Color(color: UIColor(red: 245/255, green: 215/255, blue: 110/255, alpha: 1), name: "Cream Can"),
        Color(color: UIColor(red: 247/255, green: 202/255, blue: 24/255, alpha: 1), name: "Ripe Lemon"),
        Color(color: UIColor(red: 244/255, green: 208/255, blue: 63/255, alpha: 1), name: "Saffron"),
        Color(color: UIColor(red: 253/255, green: 227/255, blue: 167/255, alpha: 1), name: "Cape Honey"),
        Color(color: UIColor(red: 248/255, green: 148/255, blue: 6/255, alpha: 1), name: "California"),
        Color(color: UIColor(red: 235/255, green: 149/255, blue: 50/255, alpha: 1), name: "Fire Bush"),
        Color(color: UIColor(red: 232/255, green: 126/255, blue: 4/255, alpha: 1), name: "Tahiti Gold"),
        Color(color: UIColor(red: 244/255, green: 179/255, blue: 80/255, alpha: 1), name: "Casablanca"),
        Color(color: UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1), name: "White Smoke"),
        Color(color: UIColor(red: 210/255, green: 215/255, blue: 211/255, alpha: 1), name: "Pumice"),
        Color(color: UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1), name: "Silver Sand")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView!.backgroundColor = getBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count;
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ColorCell
        // Configure the cell
        let color:Color = colors[ indexPath.row ]
        cell.colorView.backgroundColor = color.color
        cell.textLabel.text = color.name
        cell.layer.cornerRadius = 9.0
        cell.layer.borderColor = UIColor.blackColor().CGColor//UIColor.grayColor().CGColor
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let newColor = colors[ indexPath.row ]
        self.collectionView!.backgroundColor = newColor.color
        setBackgroundColor( newColor.color )
    }

}
