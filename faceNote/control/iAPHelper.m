//
//  iAPHelper.m
//  faceNote
//
//  Created by 林景隆 on 4/18/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "iAPHelper.h"
#import "UICKeyChainStore.h"

@interface iAPHelper()<SKPaymentTransactionObserver,SKProductsRequestDelegate,SKRequestDelegate>
{
    SKProduct *iCloudSynchronizationProduct;
}

@property (copy)QUERYBLOCK queryBlock;
@property (copy)BUYICLOUDSYNCHRONIZATIONBLOCK buyICloudSynchronizationBlock;

@end

@implementation iAPHelper
@synthesize products,queryBlock,bPurchased,buyICloudSynchronizationBlock;

+ (iAPHelper*)helper
{
    static iAPHelper *g_iapHelper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(){
        g_iapHelper = [[iAPHelper alloc] init];
    });
    return g_iapHelper;
}

- (id)init
{
    self = [super init];
    if( self ){
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        products = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *purchased = [[UICKeyChainStore keyChainStore] stringForKey:kICloudPurchased];
        if( purchased && [purchased isEqualToString:@"YES"] ){
            bPurchased = YES;
        }
        else{
            bPurchased = NO;
        }
    }
    return self;
}

- (void)queryProductsWithBlock:(void(^)(int status))block
{
    self.queryBlock = block;
    NSSet *set = [NSSet setWithObjects:ICLOUD_SYNCHRONIZATION_PRODUCT_ID, nil];
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
            self.bPurchased = YES;
            [[UICKeyChainStore keyChainStore] setString:@"YES" forKey:kICloudPurchased];
            NSLog(@"%s transaction id:%@", __func__, transaction.transactionIdentifier);
            if( buyICloudSynchronizationBlock ){
                buyICloudSynchronizationBlock( 0 );
            }
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        case SKPaymentTransactionStateFailed:
            state = @"SKPaymentTransactionStateFailed";
            if( ![transaction.error.localizedDescription isEqualToString:@"Cannot connect to iTunes Store"] ){
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
            if( buyICloudSynchronizationBlock ){
                buyICloudSynchronizationBlock( 99 );
            }
            break;
        case SKPaymentTransactionStateRestored:
            state = @"SKPaymentTransactionStateRestored";
            self.bPurchased = NO;
            [[UICKeyChainStore keyChainStore] setString:@"NO" forKey:kICloudPurchased];
            break;
    }
    NSLog(@"%s, state:%@, error:%@,error code:%d", __func__, state, transaction.error.localizedDescription, transaction.error.code);
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"%s", __func__);
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"%s,error code:%d, %@", __func__, error.code, error.localizedDescription);
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
    
    for( SKProduct *product in response.products ){
        if( [product.productIdentifier isEqualToString:ICLOUD_SYNCHRONIZATION_PRODUCT_ID] ){
            iCloudSynchronizationProduct = product;
            break;
        }
    }
    
    if( iCloudSynchronizationProduct ){
        NSLog(@"product id:%@, title:%@, description:%@", iCloudSynchronizationProduct.productIdentifier, iCloudSynchronizationProduct.localizedTitle, iCloudSynchronizationProduct.localizedDescription);
        [self buyProduct:iCloudSynchronizationProduct];
    }
    else{
        if( buyICloudSynchronizationBlock ){
            buyICloudSynchronizationBlock( 99 );
        }
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
    if( buyICloudSynchronizationBlock ){
        buyICloudSynchronizationBlock( 99 );
    }
}

- (void)buyProduct:(id)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)buyICloudSynchronizationProductWithBlock:(BUYICLOUDSYNCHRONIZATIONBLOCK)block
{
    self.buyICloudSynchronizationBlock = block;
    NSSet *set = [NSSet setWithObjects:ICLOUD_SYNCHRONIZATION_PRODUCT_ID, nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

@end
