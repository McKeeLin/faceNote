//
//  iAPHelper.m
//  faceNote
//
//  Created by 林景隆 on 4/18/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "iAPHelper.h"

@interface iAPHelper()<SKPaymentTransactionObserver,SKProductsRequestDelegate,SKRequestDelegate>
{
    
}
@property (copy)QUERYBLOCK queryBlock;

@end

@implementation iAPHelper
@synthesize products,queryBlock;

- (id)init
{
    self = [super init];
    if( self ){
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        products = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)queryProductsWithBlock:(void(^)(int status))block
{
    self.queryBlock = block;
    NSSet *set = [NSSet setWithObjects:PRODUCT1_ID, PRODUCT2_ID, PRODUCT3_ID, nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

- (void)dealloc
{
    [queryBlock release];
    [products release];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [super dealloc];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    SKPaymentTransaction *transaction = [transactions firstObject];
    NSString *state;
    switch( transaction.transactionState )
    {
        case SKPaymentTransactionStatePurchasing:
            state = @"SKPaymentTransactionStatePurchasing";
            break;
        case SKPaymentTransactionStatePurchased:
            state = @"SKPaymentTransactionStatePurchased";
            break;
        case SKPaymentTransactionStateFailed:
            state = @"SKPaymentTransactionStateFailed";
            break;
        case SKPaymentTransactionStateRestored:
            state = @"SKPaymentTransactionStateRestored";
            break;
    }
    NSLog(@"%s, state:%@", __func__, state);
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"%s", __func__);
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"%s", __func__);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"%s", __func__);
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"%s", __func__);
    [products removeAllObjects];
    [products addObjectsFromArray:response.products];
    if( queryBlock ){
        queryBlock( 0 );
    }
}

#pragma mark - SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"%s", __func__);
    ;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s,error:%@", __func__, error.localizedDescription);
}

- (void)buyProduct:(id)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end
