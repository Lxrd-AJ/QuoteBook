//
//  ColorButton.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 27/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 0.7
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.cornerRadius = self.bounds.width / 2.0
    }
}
