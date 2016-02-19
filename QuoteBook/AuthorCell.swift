//
//  AuthorCell.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 03/01/2016.
//  Copyright © 2016 The Leaf Enterprise. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AuthorCell: UICollectionViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var quotesCountLabel: UILabel!
    var json: JSON?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
    }
}
