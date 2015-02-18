//
//  QBQuoteModel.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuoteModel.h"
#import "QBQuote.h"
#import "QuoteBook-Swift.h"

@interface QBQuoteModel()

@property(nonatomic,strong) NSMutableArray *downloadedQuotes;

@end

@implementation QBQuoteModel

-(id)init
{
    self = [super init];
    if (self) {
        self.downloadedQuotes = [[NSMutableArray alloc] init];
        [self loadTestData];
    }
    return self;
}

-(void)loadTestData
{
    //create a new quote
    QBQuote *quote = [[QBQuote alloc] init];
    [quote setTitle:@"Imagination" forQuote:@"Imagination is more important than knowledge"];
    [quote setQuoteAuthor:@"Albert Einstein"];
    [quote setAuthorImageProperty:[UIImage imageNamed:@"finger"]];
    
    NSDictionary *testQuotes = [[NSDictionary alloc] init];
    testQuotes = @{
        @"1" : @{
                @"Author" : @"Eric Thomas",
                @"Title" : @"TGIM",
                @"Quote" : @"When you want to succeed as bad as you want to    breathe, then you'll be successful"
                },
        @"2" : @{
                @"Author" : @"Albert Einstein",
                @"Title" : @"Imagination",
                @"Quote" : @"Imagination is more important than knowledge"
                }
    };
    
    [self.downloadedQuotes addObject:quote];
}

-(QBQuote *)getLastQuote
{
    return [self.downloadedQuotes lastObject];
}

@end
