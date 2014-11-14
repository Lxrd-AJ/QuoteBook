//
//  QBQuoteModel.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuoteModel.h"
#import "QBNetworkClient.h"
#import "QBQuote.h"

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
    [quote setTitle:@"Imagination" for:@"Imagination is more important then knowledge"];
    [quote setAuthor:@"Albert Einstein"];
    [quote setAuthorImageProperty:[UIImage imageNamed:@"finger.jpg"]];
    
    [self.downloadedQuotes addObject:quote];
}

-(QBQuote *)getLastQuote
{
    return [self.downloadedQuotes lastObject];
}

@end
