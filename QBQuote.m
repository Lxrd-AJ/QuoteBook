//
//  QBQuote.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuote.h"

@interface QBQuote()

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *body;
@property(nonatomic,strong) NSString *author;

@end

@implementation QBQuote

-(instancetype)init
{
    self = [super init];
    if (self) {
        //do stuff
    }
    return self;
}

@end
