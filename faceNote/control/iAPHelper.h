//
//  iAPHelper.h
//  faceNote
//
//  Created by 林景隆 on 4/18/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define PRODUCT1_ID    @"com.mckeelin.facenote.nuncuomsumable"
#define PRODUCT2_ID    @"facenote.savetoiCloud"
#define PRODUCT3_ID    @"facenote.removeFromiCloud"

typedef void(^QUERYBLOCK)(int status);

@interface iAPHelper : NSObject

@property NSMutableArray *products;
@property BOOL bPurchased;

- (void)queryProductsWithBlock:(QUERYBLOCK)block;

- (void)buyProduct:(SKProduct*)product;

+ (iAPHelper*)helper;

@end
