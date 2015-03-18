//
//  LoadingModel.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 01/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

//TODO: Use Network Adaoter here instead
class LoadingModel: QBQuoteModel {
    var randomQuote:QBQuote?
    var quote = QBQuote()
    
    //TODO: Create a Loading View for any animations that need to be done for
    override init(){
        quote.setTitle("Patience", forQuote: "Patience is a virtue \n\nFetching your quotes....")
        quote.setQuoteAuthor("QuoteBook App")
        super.init()
    }
   
    override func getNextQuote() -> QBQuote! {
        return self.quote
    }
    
    override func getPreviousQuote() -> QBQuote! {
        return getNextQuote()
    }
    
    func setRandomQuoteString( quoteString:String ) {
        let quote = QBQuote()
        quote.setTitle("Random", forQuote: quoteString )
        quote.setQuoteAuthor("I❤️Quote")
        self.quote = quote
    }
    
    func getRandomQuote() -> QBQuote? {
        return self.randomQuote
    }
    
}
