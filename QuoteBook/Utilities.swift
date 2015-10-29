//
//  Utilities.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 20/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import Foundation

let ERROR:String = "ERROR";
let BACKGROUND_COLOR:String = "BACKGROUND_COLOR"
let USER_QUOTE:String = "USER_QUOTE"

extension UIView {
    class func loadFromNibName( nibNamed:String, bundle:NSBundle? = nil ) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiateWithOwner(nil , options: nil)[0] as? UIView
    }
}

extension Array {
    /** Randomizes the order of an array's elements. */
    mutating func shuffle(){
        for _ in 0..<10{
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

func getBackgroundColor() -> UIColor {
    if let colorData = NSUserDefaults(suiteName: "group.com.TheLeaf.QuoteBook")!.objectForKey(BACKGROUND_COLOR) as? NSData{
        return NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as! UIColor
    }else{
        return UIColor(red: 75, green: 255, blue: 75, alpha: 0.3)
    }
}

func setBackgroundColor( color:UIColor ) {
    let colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
    NSUserDefaults(suiteName: "group.com.TheLeaf.QuoteBook")!.setObject(colorData, forKey: BACKGROUND_COLOR)
}
