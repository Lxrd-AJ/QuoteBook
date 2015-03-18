//
//  QBQuoteViewController.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuoteViewController.h"
#import "QBQuote.h"
#import "QBQuoteView.h"
#import "QuoteBook-Swift.h"

@interface QBQuoteViewController ()

@property(nonatomic,strong) QBQuoteView *quoteView;
@property(nonatomic,strong) QBQuote *quote;

@end

@implementation QBQuoteViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.quoteView = [[QBQuoteView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.view = self.quoteView;
        self.quote = [[QBQuote alloc] init];
    }
    return self;
}

-(void)initQuoteViewWith:(QBQuote *)quote
{
    [self.quoteView designViewWithQuote:quote];
}

-(void)setQuote:(QBQuote *)newQuote
{
    //self.quote = newQuote;
    [self initQuoteViewWith:newQuote];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
