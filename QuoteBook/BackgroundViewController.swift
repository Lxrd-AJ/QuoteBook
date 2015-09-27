//
//  BackgroundViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 27/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class BackgroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let colorData = NSUserDefaults.standardUserDefaults().objectForKey(BACKGROUND_COLOR) as? NSData{
            self.view.backgroundColor = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeColor(sender: ColorButton) {
        self.view.backgroundColor = sender.backgroundColor
        let colorData = NSKeyedArchiver.archivedDataWithRootObject(sender.backgroundColor!)
        NSUserDefaults.standardUserDefaults().setObject(colorData, forKey: BACKGROUND_COLOR)
        
    }

}
