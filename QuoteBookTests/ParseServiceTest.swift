//
//  ParseService.swift
//  QuoteBook
//
//  Created by AJ Ibraheem on 20/09/2015.
//  Copyright © 2015 The Leaf Enterprise. All rights reserved.
//

import XCTest
import Parse

class ParseServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseObjectToQuote(){
        self.measureBlock({
            let obj = PFObject(className: "Quote")
            obj["quote"] = "Hola come tues to"
            obj["author"] = "Madmoiselle La petitie"
            obj["Tag"] = "Test"
            do{
                try obj.save()
            }catch{
                print("Failed to Save object")
            }
            
            let quote = ParseService.parseObjectToQuote(obj)
            XCTAssertNotNil(quote, "Quote Object is nil")
            XCTAssert( quote.author == (obj["author"] as! String) )
            
            defer {
                do{ try obj.delete() }
                catch{ print(error) }
            }
        })
    }
    
    
    func testQuotesStoredInLocalStore(){
        let expectation:XCTestExpectation = expectationWithDescription("Fetching Quotes from local datastore")
        ParseService.fetchQuotes({ (quotes:[Quote]) -> Void in
            let query = PFQuery(className: "Quote")
            query.fromLocalDatastore()
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                XCTAssertTrue(quotes.count == objects?.count, "Number fetched from server equals local amount")
                expectation.fulfill()
            })
        })

        waitForExpectationsWithTimeout(15.0, handler: { (error) in
            XCTAssertNotNil(error , "Failed to execute test within resonable time")
        })
    }
    
}
