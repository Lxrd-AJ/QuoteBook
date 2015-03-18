//
//  PageViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/02/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, NetworkAdapterDelegate {
    
    var model:LoadingModel = LoadingModel() {
        didSet {
            self.setup()
        }
    }
    var count:Int{
        get{
            return model.quoteCount()
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [NSObject : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.dataSource = self
        self.delegate = self
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        let cont = QBQuoteViewController()
        cont.setQuote( model.getNextQuote() )
        self.setViewControllers([cont], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
}

extension PageViewController: UIPageViewControllerDelegate {
   
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let cont = QBQuoteViewController()
        cont.setQuote( model.getPreviousQuote() ) //TODO: If nil returned, no new quotes
        return cont
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let cont = QBQuoteViewController()
        cont.setQuote( model.getNextQuote() ) //TODO: If nil returned, no new quotes
        return cont
    }
}

extension PageViewController: NetworkAdapterDelegate {
    func clientDidFinishDownloading(sender: NSObject, data: NSString, status: DownloadStatus) {
        switch status {
        case .NewQuotes:
            self.model.setRandomQuoteString( data as String )
        default:
            self.model.setRandomQuoteString("No new quotes for now 😩")
        }
        //setup()
    }
}