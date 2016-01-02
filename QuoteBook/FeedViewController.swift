//
//  FeedViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 29/11/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit
import SwiftSpinner

class FeedViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    var quotes:[Quote] = []
    let refreshControl:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundView = createTextLabelWithMessage("This is a bit awkward,I seem to have no Data \n Please pull to refresh")
        
        //Pull to Refresh UI
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "fetchQuotes", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        SwiftSpinner.show("Patience is a Virtue \n Fetching your quotes")
        fetchQuotes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 1.0
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Quotes Feed"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont(name: "Baskerville", size: 20)!]
        refreshControl.backgroundColor = getBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        UIView.animateWithDuration(0.2, animations: { self.view.alpha = 0.0 })
        if let destController = segue.destinationViewController as? PageViewController, selectedRowIdx = self.tableView.indexPathForSelectedRow?.row {
            destController.quotes = self.quotes
            destController.index = selectedRowIdx
            destController.shouldFetchQuotes = false
        }
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true)
    }
    
    func fetchQuotes() {
        //Fetch the top quotes
        ParseService.fetchQuotes({(quotes:[Quote]) -> Void in
            self.quotes = quotes
            if self.refreshControl.refreshing { self.refreshControl.endRefreshing() }
            if quotes.count == 0 {
                SwiftSpinner.show("😑😑 Err, It seems I can't connect to the mothership now.").addTapHandler({
                    SwiftSpinner.hide()
                    }, subtitle: "Try again when there is an internet connection")
            }else{
                self.tableView.reloadData()
                SwiftSpinner.hide()
            }
        })

    }
    
    func createTextLabelWithMessage( text:String ) -> UILabel {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.sizeToFit()
        return label
    }

}

extension FeedViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (quotes.count == 0) ? 0 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:FeedCell = self.tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedCell
        cell.quoteLabel.text = quotes[indexPath.row].quote
        cell.authorLabel.text = quotes[indexPath.row].author
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(red: 245/255, green: 215/255, blue: 110/255, alpha: 1)
        cell.selectedBackgroundView = selectionView
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}
