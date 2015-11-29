//
//  AuthorsViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 29/11/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class AuthorsViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension AuthorsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AuthorCell = self.tableView.dequeueReusableCellWithIdentifier("AuthorCell", forIndexPath: indexPath) as! AuthorCell
        //cell.testLabel.text = "Hello Cruel Author"
        return cell
    }
}

extension AuthorsViewController: UITableViewDelegate {
    
}
