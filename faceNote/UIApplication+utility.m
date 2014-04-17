//
//  UIApplication+utility.m
//  OA
//
//  Created by 林景隆 on 14-3-2.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "UIApplication+utility.h"

@implementation UIApplication (utility)

+ (CGFloat)systemVersion
{
    return [UIDevice currentDevice].systemVersion.floatValue;
}


+ (CGSize)appSize
{
    CGSize size;
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGRect bounds = [UIScreen mainScreen].bounds;
    if( [UIApplication systemVersion] >= 7.0 )
    {
        if( frame.size.height == bounds.size.height ) // landspace
        {
            size.width = bounds.size.height;
            size.height = bounds.size.width;
        }
        else // portrait
        {
            size = bounds.size;
        }
    }
    else
    {
        if( frame.size.height == bounds.size.height ) // landspace
        {
            size.width = frame.size.height;
            size.height = frame.size.width;
        }
        else // portrait
        {
            size = frame.size;
        }
    }
    return size;
}

@end
