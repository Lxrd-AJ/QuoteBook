//
//  LoadingViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    let loadingView = LoadingView()
    var pageController:PageViewController?
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        self.view = self.loadingView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadingView.designViewWithQuote()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension LoadingViewController: ModelDelegate {
    func didFinishDownloadingData(#sender: NSObject) {
        self.view.subviews.map{ $0.removeFromSuperview() }
        let model = sender as! Model
        if model.quoteCount() == 0 {
            self.loadingView.designWithNoQuote()
        }else{
            self.pageController = PageViewController( transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil )
            self.pageController!.model = sender as! Model
            self.presentViewController(self.pageController!, animated: true, completion: nil)
        }
    }
    
    func didFinishBackgroundFetch(#sender: Model) {
        self.pageController!.model = sender;
    }
}
