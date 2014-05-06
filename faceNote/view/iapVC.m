//
//  iapVC.m
//  faceNote
//
//  Created by 林景隆 on 4/18/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "iapVC.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import "iAPHelper.h"

@interface iapVC ()
{
    MBProgressHUD *hub;
    iAPHelper *iap;
}
@end

@implementation iapVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [iap release];
    [hub release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iap = [[iAPHelper alloc] init];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    tgr.numberOfTapsRequired = 2;
    tgr.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:tgr];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [iap queryProductsWithBlock:^(int status){
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iap.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"iapCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if( !cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    // Configure the cell...
    SKProduct *product = [iap.products objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", product.localizedTitle];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f（元）", product.price.floatValue];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.bounds.size.width;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-15, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.text = @"捐赠";
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 25)] autorelease];
    [headerView addSubview:label];
    [label release];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct *product = [iap.products objectAtIndex:indexPath.row];
    [iap buyProduct:product];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    SKPaymentTransaction *transaction = [transactions objectAtIndex:0];
    if( transaction.transactionState == SKPaymentTransactionStatePurchasing )
    {
        NSLog(@"%s, state is:SKPaymentTransactionStatePurchasing", __func__);
    }
    else if( transaction.transactionState == SKPaymentTransactionStatePurchased ){
        NSLog(@"%s, state is:SKPaymentTransactionStatePurchased", __func__);
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    else if( transaction.transactionState == SKPaymentTransactionStateFailed ){
        NSLog(@"%s, state is:SKPaymentTransactionStateFailed", __func__);
    }
    else if( transaction.transactionState == SKPaymentTransactionStateRestored ){
        NSLog(@"%s, state is:SKPaymentTransactionStateRestored", __func__);
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}


- (void)onDoubleTap:(UITapGestureRecognizer*)tgr
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
