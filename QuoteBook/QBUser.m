//
//  QBUser.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBUser.h"

@interface QBUser()

@property(nonatomic,strong) NSString *firstName;
@property(nonatomic,strong) NSString *lastName;
@property(nonatomic,strong) UIImage *profilePicture;
@property(nonatomic,strong) NSArray *quotes;

@end

@implementation QBUser

-(id)init
{
    self = [super init];
    if (self) {
        //do some syuff
    }
    return self;
}

@end
