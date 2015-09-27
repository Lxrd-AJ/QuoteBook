//
//  PageViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/02/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var loadingController:QuoteViewController = QuoteViewController()
    var quotes:[Quote] = []
    var quotesViewControllers:[QuoteViewController] = []
    var index:Int = 0{
        didSet{
            if( index < 0 ){ index = quotes.count - 1 }
            else{ index = index % quotes.count; }
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidLoad() {
        //Setup
        let loadingQuote:Quote = Quote(quote: "Patience is a virtue \n\nFetching your quotes....", author: "QuoteBook App", tag: ERROR );
        loadingController = newPage( loadingQuote );
        self.setViewControllers([loadingController], direction: .Forward, animated: true, completion: nil)
        ParseService.fetchQuotes({ (quotes:[Quote]) -> Void in
            self.quotes = quotes
            self.quotes.shuffle()
            if quotes.count == 0 {
                let quote:Quote = Quote()
                quote.quote = "😑😑 Err, It seems I can't connect to the mothership now.\n Try again when there is an internet connection"
                quote.author = "QuoteBook Maestro📱"
                quote.tag = ERROR;
                self.setViewControllers([self.newPage(quote)], direction: .Forward, animated: true, completion: nil)
            }else{
                self.quotesViewControllers = self.quotes.map( self.newPage )
                self.setViewControllers( [self.newPage(self.quotes[0])], direction: .Forward, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newPage( quote:Quote ) -> QuoteViewController {
        let quoteView = QuoteView.instanceFromNib()
        let res = QuoteViewController()
        quoteView.quoteTextView.text = quote.quote!
        quoteView.titleLabel.text = quote.author!
        res.view = quoteView
        res.quote = quote;
        return res
    }
    
    func refreshViewControllers(){
        let controllers = (self.viewControllers as! [QuoteViewController]) + self.quotesViewControllers
        _ = controllers.map{ c in UIView.animateWithDuration(0.3, animations: { c.view.backgroundColor = getBackgroundColor() })}
    }
}

extension PageViewController: UIPageViewControllerDelegate {
   
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard quotes.count != 0 else{ return nil }
        return quotesViewControllers[ index-- ]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard quotes.count != 0 else{ return nil }
        return quotesViewControllers[ index++ ]
    }
}
