//
//  UIColor+utility.m
//  OA
//
//  Created by 林景隆 on 14-3-2.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "UIColor+utility.h"

@implementation UIColor (utility)

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    return result;
}


@end
