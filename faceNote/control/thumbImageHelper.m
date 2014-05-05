//
//  thumbImageHelper.m
//  faceNote
//
//  Created by 林景隆 on 5/3/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "thumbImageHelper.h"

@implementation thumbImageHelper
@synthesize thumbImages;

+ (thumbImageHelper*)helper
{
    static thumbImageHelper *thumbHelper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(void){
        thumbHelper = [[thumbImageHelper alloc] init];
        NSLog(@"%s", __func__);
    });
    return thumbHelper;
}

- (id)init
{
    self = [super init];
    if( self ){
        thumbImages = [[NSMutableDictionary alloc] init];
    }
    return  self;
}

@end
