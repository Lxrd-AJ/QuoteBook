//
//  QBLabel.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 14/11/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBLabel.h"

@implementation QBLabel


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.textAlignment = NSTextAlignmentCenter;
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:40]];
        self.numberOfLines = 0;
        self.textColor = [UIColor blackColor];
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = { 0,15,0,15 };
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
