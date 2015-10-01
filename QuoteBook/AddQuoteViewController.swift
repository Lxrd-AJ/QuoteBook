//
//  AddQuoteViewController.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 30/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class AddQuoteViewController: UIViewController {
    
    @IBOutlet weak var authorTextField:UITextField!
    @IBOutlet weak var quoteTextView:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func saveQuote(sender: UIButton) {
        //check if the quotes or author are not nil 
        if( (authorTextField.text != "") && (quoteTextView.text != "") ){
            //save the quote
            let quote:Quote = Quote(quote: quoteTextView.text, author: authorTextField.text!, tag: USER_QUOTE )
            let object = ParseService.parseQuoteToObject(quote)
            do{ try object.pin() }
            catch{ print(error) }
        }else{
            let alertController = UIAlertController(title: "Errr", message: "You have to enter an author and a quote, 😑😑", preferredStyle: .Alert )
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction( cancelAction )
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel( sender:UIButton ) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
