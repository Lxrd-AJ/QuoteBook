//
//  LoadingViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    let loadingView = QuoteView.instanceFromNib()
    var pageController:PageViewController?
    
//    override init() {
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loadingView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadingView.titleLabel.text = "QuoteBook App"
        loadingView.quoteTextView.text = "Patience is a virtue \n\nFetching your quotes...."
    }

}

extension LoadingViewController: ModelDelegate {
    func didFinishDownloadingData(sender sender: NSObject) {
        _ = self.view.subviews.map{ $0.removeFromSuperview() }
        let model = sender as! Model
        if model.quoteCount() == 0 {
            //self.loadingView.designWithNoQuote()
        }else{
            self.pageController = PageViewController( transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil )
            self.pageController!.model = sender as! Model
            self.presentViewController(self.pageController!, animated: true, completion: nil)
        }
    }
    
    func didFinishBackgroundFetch(sender sender: Model) {
        self.pageController!.model = sender;
    }
}
