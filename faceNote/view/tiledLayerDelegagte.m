//
//  tiledLayerDelegagte.m
//  OA
//
//  Created by 林景隆 on 5/14/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "tiledLayerDelegagte.h"

@implementation tiledLayerDelegagte
@synthesize image,bounds;


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    NSLog(@"%s", __func__);
    CGFloat boundsWidth = bounds.size.width;
    CGFloat boundsHeight = bounds.size.height;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rate = imageHeight / imageWidth;
    CGContextDrawImage(ctx, CGRectMake(0, (boundsHeight-boundsWidth*rate)/2,boundsWidth, boundsWidth*rate), image.CGImage);
}


- (void)dealloc
{
    [image release];
    [super dealloc];
}

@end
