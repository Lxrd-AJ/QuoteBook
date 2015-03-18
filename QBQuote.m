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
@property(nonatomic,strong) NSString *quote;
@property(nonatomic,strong) NSString *author;
@property(nonatomic,strong) UIImageView *authorImage;

@end

@implementation QBQuote


-(id)init
{
    self = [super init];
    if (self != nil) {
        //do stuff
        self.title = @"Dummy Text";
    }
    return self;
}

-(void)setQuoteAuthor:(NSString *)author
{
    self.author = [[NSString alloc] initWithString:author];
}

-(void)set:(NSString *)quote
{
    self.quote = [[NSString alloc] initWithString:quote];
}

-(void)setQuoteTitle:(NSString *)mtitle
{
    self.title = mtitle;
}

-(void)setTitle:(NSString *)title forQuote:(NSString *)quote
{
    [self setQuoteTitle:title];
    self.quote = [[NSString alloc] initWithString:quote];
}

-(void)setAuthorImageProperty:(UIImage *)image
{
    UIImage *result = nil;
    if (image) {
        //resize the image
        CGSize imageSize = CGSizeMake(20.0, 20.0);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0 );
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    self.authorImage.layer.cornerRadius = self.authorImage.frame.size.height / 2;
    self.authorImage.layer.masksToBounds = YES;
    self.authorImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.authorImage.layer.borderWidth = 0.5f;
    self.authorImage.image = result;
}

-(UIImageView *)getAuthorImage
{
    return self.authorImage;
}

-(NSString*)getQuoteText
{
    return self.quote;
}

-(NSString*)getQuoteAuthor
{
    return self.author;
}



@end
