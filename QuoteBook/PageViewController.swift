//
//  PageViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/02/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var model:Model = Model() {
        didSet {
            self.setup()
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [NSObject : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.dataSource = self
        self.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        let cont = QBQuoteViewController()
        cont.setQuote( model.nextQuote() )
        self.setViewControllers([cont], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
   
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let cont = QBQuoteViewController()
        cont.setQuote( model.previousQuote() ) //TODO: If nil returned, no new quotes
        return cont
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let cont = QBQuoteViewController()
        cont.setQuote( model.nextQuote() ) //TODO: If nil returned, no new quotes
        return cont
    }
}
