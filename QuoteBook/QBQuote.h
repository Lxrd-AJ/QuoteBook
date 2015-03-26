//
//  QBQuote.h
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface QBQuote : NSObject

-(void)setQuoteAuthor:(NSString *)author;
-(void)set:(NSString *)quote;
-(void)setTitle:(NSString *)title;
-(void)setTitle:(NSString *)title forQuote:(NSString *)quote;
-(void)setAuthorImageProperty:(UIImage *)image;
-(NSString*)getQuoteAuthor;

-(UIImageView *)getAuthorImage;
-(NSString *)getQuoteText;
+(QBQuote *)endQuote;

@end
