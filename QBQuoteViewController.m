//
//  QBQuoteViewController.m
//  QuoteBook
//
//  Created by AJ Ibraheem on 06/10/2014.
//  Copyright (c) 2014 The Leaf Enterprise. All rights reserved.
//

#import "QBQuoteViewController.h"
#import "QBQuoteModel.h"
#import "QBQuoteView.h"

@interface QBQuoteViewController ()

@property(nonatomic,strong) QBQuoteView *quoteView;
@property(nonatomic,strong) QBQuoteModel *model;

@end

@implementation QBQuoteViewController

-(id)init
{
    self = [super init];
    if (self) {
        self.quoteView = [[QBQuoteView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.view = self.quoteView;
        [self initQuoteView];
        //initialise the model
        self.model = [[QBQuoteModel alloc] init];
    }
    return self;
}

-(void)initQuoteView
{
    //get the quote
    QBQuote *quote = [self.model getLastQuote];
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
