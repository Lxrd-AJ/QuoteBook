//
//  QuoteView.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 20/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class QuoteView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addQuoteButton: UIButton!
    
    class func instanceFromNib() -> QuoteView {
        let view = UIView.loadFromNibName("QuoteView") as! QuoteView
        if let colorData = NSUserDefaults.standardUserDefaults().objectForKey(BACKGROUND_COLOR) as? NSData{
            view.backgroundColor = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }else{
            view.backgroundColor = UIColor(red: 75, green: 255, blue: 75, alpha: 0.3)
        }
        view.backgroundColor = getBackgroundColor()
        return view;
    }
    
}
