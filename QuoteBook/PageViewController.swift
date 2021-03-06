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
    var shouldFetchQuotes: Bool = true
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
        super.init(coder: aDecoder)
        self.dataSource = self
        self.delegate = self
    }
    
    override func viewDidLoad() {
        //Setup
        if shouldFetchQuotes {
            let loadingQuote:Quote = Quote(quote: "Patience is a virtue \n\nFetching your quotes....", author: "QuoteBook App", tag: ERROR );
            loadingController = newPage( loadingQuote,index: 0 );
            self.setViewControllers([loadingController], direction: .Forward, animated: true, completion: nil)
            ParseService.fetchQuotes({ (quotes:[Quote]) -> Void in
                self.quotes = quotes
                self.setupViewControllersWithQuotes(quotes)
            })
        }else{ setupViewControllersWithQuotes(self.quotes) }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshViewControllers()
        
        //If notified about a new Quote, then call setUpQuotes
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.remoteQuoteID != nil {
            //TODO: Find a way to present the new quote
            appDelegate.remoteQuoteID = nil ;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewControllersWithQuotes( quotes:[Quote] ){
        self.quotes = quotes
        //self.quotes.shuffle()
        //sort the quotes by creation date
        self.quotes.sortInPlace({ $0.createdAt!.compare($1.createdAt!) == .OrderedDescending })
        if quotes.count == 0 {
            let quote:Quote = Quote()
            quote.quote = "😑😑 Err, It seems I can't connect to the mothership now.\n Try again when there is an internet connection"
            quote.author = "QuoteBook Maestro📱"
            quote.tag = ERROR;
            self.setViewControllers([self.newPage(quote,index: 0)], direction: .Forward, animated: true, completion: nil)
        }else{
            //self.quotesViewControllers = self.quotes.map( self.newPage )
            var counter = -1;
            self.quotesViewControllers = self.quotes.map({ quote in
                return self.newPage(quote, index: ++counter)
            })
            //TODO: if there is a first quote in AppDelegate then use it as the initial VC
            self.setViewControllers( [self.quotesViewControllers[index]], direction: .Forward, animated: true, completion: nil)
        }

    }
    
    func newPage( quote:Quote , index:Int ) -> QuoteViewController {
        let quoteView = QuoteView.instanceFromNib()
        let res = QuoteViewController()
        quoteView.quoteTextView.text = quote.quote!
        quoteView.titleLabel.text = quote.author!
        res.view = quoteView
        res.quote = quote;
        res.index = index;
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
        var idx:Int = (viewController as! QuoteViewController).index
        if idx <= 0 { return quotesViewControllers[ quotes.count - 1 ] }
        else{ return quotesViewControllers[ --idx ] }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard quotes.count != 0 else{ return nil }
        var idx:Int = (viewController as! QuoteViewController).index
        if idx >= quotesViewControllers.count-1 { return quotesViewControllers[0] }
        else{ return quotesViewControllers[ ++idx ] }
    }
}
