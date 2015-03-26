//
//  LoadingView.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 18/03/2015.
//  Copyright (c) 2015 The Leaf Enterprise. All rights reserved.
//

import UIKit

class LoadingView: QBQuoteView {

    let loadingQuote:QBQuote = QBQuote()
    
    func designViewWithQuote() {
        loadingQuote.setTitle("Patience", forQuote: "Patience is a virtue \n\nFetching your quotes....")
        loadingQuote.setQuoteAuthor("QuoteBook App")
        super.designViewWithQuote( loadingQuote )
    }
    
    func designWithNoQuote() {
        loadingQuote.setTitle("Oops!", forQuote: "Something went wrong \nThere seem to be no quotes 😩!")
        loadingQuote.setQuoteAuthor("QuoteBook App")
        super.designViewWithQuote( loadingQuote )
    }

}
