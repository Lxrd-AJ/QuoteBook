//
//  QBQuoteView.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuoteView.h"
#import "QBLabel.h"

@interface QBQuoteView()

@property(nonatomic,strong) UIImageView *profilePicture;
@property(nonatomic,strong) QBLabel *quoteLabel;
@property(nonatomic,strong) QBLabel *authorLabel;
@property(nonatomic,strong) QBLabel *titleLabel;

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

-(void)designViewWithQuote:(QBQuote *)quote
{
    CGRect screen = [UIScreen mainScreen].bounds ;
    CGRect frame = CGRectMake(screen.origin.x * 0, screen.size.height * 0.1, screen.size.width, screen.size.height  * 0.9);
    //method loads all the necessary data into the view
    //------------------BUG FIX-----------------
    //Image not showing in app
    self.profilePicture = [quote getAuthorImage];
    self.profilePicture.frame = CGRectMake(10, 20, 50, 50);
    [self addSubview:self.profilePicture];
    NSLog(@"%@", self.profilePicture);
    
    //Add the Quote to the View
    self.quoteLabel = [[QBLabel alloc] initWithFrame:frame];
    [self.quoteLabel setText:[quote getQuoteText]];
    [self addSubview:self.quoteLabel];
    NSLog(@"%@",self.quoteLabel.text);
    
    //----------------------BUG FIX-------------
    //Author Label not positioned properly
    //----Add the author to the view
    self.authorLabel = [[QBLabel alloc] initWithFrame:CGRectMake(0, screen.size.height * 0 , screen.size.width, screen.size.height * 0.15)];
    self.authorLabel.text = [quote getQuoteAuthor];
    [self addSubview:self.authorLabel];
    [self.authorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    NSLog(@"%@", self.authorLabel.text);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
