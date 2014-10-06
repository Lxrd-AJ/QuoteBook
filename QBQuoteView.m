//
//  QBQuoteView.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuoteView.h"

@interface QBQuoteView()

@property(nonatomic,strong) UIImage *profilePicture;
@property(nonatomic,strong) NSString *quote;

@end

@implementation QBQuoteView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:75.0f green:255.0f blue:75.0f alpha:0.3f];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
