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
    CGFloat boundsWidth = bounds.size.width;
    CGFloat boundsHeight = bounds.size.height;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    NSLog(@"%s[%@], %f:%f", __func__, self,imageWidth,imageHeight);
    CGFloat rate = imageHeight / imageWidth;
    CGFloat width = boundsWidth;
    CGFloat height = boundsWidth*rate;
    CGContextRotateCTM(ctx, -M_PI/2);
    CGContextScaleCTM(ctx, boundsHeight/boundsWidth, boundsWidth/boundsHeight);
    CGContextTranslateCTM(ctx, -boundsWidth, 0);
    if( image ){
         CGContextDrawImage(ctx, CGRectMake((boundsWidth-width)/2, (boundsHeight-height)/2,width, height), image.CGImage);
    }
}


- (void)dealloc
{
    [image release];
    [super dealloc];
}

@end
