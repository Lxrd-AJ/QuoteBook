//
//  FeedCell.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 29/11/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var quoteLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
