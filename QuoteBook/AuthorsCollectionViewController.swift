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
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "AuthorCell"

class AuthorsCollectionViewController: UICollectionViewController {
    
    var authors: [Author] = []
    let imageCache = NSCache()

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAuthorViewController" ,let indexPath = self.collectionView?.indexPathsForSelectedItems()?.first {
            let authorViewController: AuthorViewController = segue.destinationViewController as! AuthorViewController
            let author = self.authors[ indexPath.item ]
            let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! AuthorCell
            authorViewController.author = author;
            authorViewController.json = cell.json
            authorViewController.backgroundImage = cell.authorImageView.image
            
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
        
        cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.5)
        cell.layer.cornerRadius = 5.0
        cell.authorNameLabel.text = author.name
        cell.authorNameLabel.sizeToFit()
        cell.authorImageView.image = nil
        cell.quotesCountLabel.hidden = true
        cell.request?.cancel()
        
        //Get the author image
        let wikiAuthorUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts|images|info&format=json&exintro=1".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        //TODO: Learn from this tutorial http://www.raywenderlich.com/85080/beginning-alamofire-tutorial and refactor this code yo!
        //TODO: Cache the JSON Response
        cell.request = Alamofire.request( .GET, wikiAuthorUrl, parameters:["titles":author.name]).responseJSON(completionHandler: { response in
            if let requestValue = response.result.value {
                if let json = self.parseWikiResponseJSON( JSON(requestValue) ) {
                    cell.json = json
                    //Get the 1st JPEG image url
                    if json["images"].isExists() {
                        if let imageName = self.getImageTitleFromWikiJSON(json["images"].array!) {
                            //Get the Image Data JSON
                            let wikiImgUrl = "https://en.wikipedia.org/w/api.php?action=query&prop=imageinfo&iiprop=url&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                            let encodingKey = response.request!.URLString
                            if let image = self.imageCache.objectForKey(encodingKey) as? UIImage {
                                cell.authorImageView.image = image
                            }else{
                                Alamofire.request( .GET, wikiImgUrl, parameters:["titles":imageName]).responseJSON { response in
                                    switch response.result {
                                    case .Success:
                                        if let value = response.result.value {
                                            let json = JSON(value)
                                            if let imgUrl = json["query"]["pages"]["-1"]["imageinfo"][0]["url"].string {
                                                Alamofire.request( .GET, imgUrl ).response { (request,response,data,error) in
                                                    if let data = data {
                                                        let image = UIImage(data: data, scale: 1)
                                                        cell.authorImageView.image = image
                                                        self.imageCache.setObject(image!, forKey: encodingKey)
                                                    }
                                                }
                                            }
                                        }
                                    case .Failure(let error):
                                        print(error)
                                    }
                                }//end requeest
                            }//end else
                        }
                    }
                }
            }
        })
        
        return cell
    }
    
    func parseWikiResponseJSON( json:JSON ) -> JSON? {
        //If query.pages.-1 exists then the author was not found on wikipedia
        if !json["query"]["pages"]["-1"].isExists() { //if the author exists in wiki
            //Set the author JSON on the cell
            if let index:[String:JSON] = json["query"]["pages"].dictionary where index.first != nil  {
                return index.first!.1
            }
        }
        return nil
    }
    
    func getImageTitleFromWikiJSON( wikiJSON:[JSON] ) -> String? {
        return wikiJSON.filter({ (json:JSON) in
            if let title = json["title"].string {
                let split = title.characters.split{ $0 == "." }.map(String.init).last
                return split?.rangeOfString("jpg|png|JPG|PNG",options: .RegularExpressionSearch) != nil
            }else{ return false }
        }).first?["title"].string
    }

}
