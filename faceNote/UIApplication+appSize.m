//
//  UIApplication+appSize.m
//  MOA
//
//  Created by cdc on 13-11-16.
//
//

#import "UIApplication+appSize.h"

@implementation UIApplication (appSize)

+ (CGSize)appSize
{
    CGSize size = CGSizeMake(0, 0);
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect appBounds = [UIScreen mainScreen].applicationFrame;
    if( screenBounds.size.width == appBounds.size.width )
    {
        size = appBounds.size;
    }
    else
    {
        size = CGSizeMake(appBounds.size.height, appBounds.size.width);
    }
    return size;
}

@end
