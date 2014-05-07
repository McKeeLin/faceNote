//
//  UIColor+utility.h
//  OA
//
//  Created by 林景隆 on 14-3-2.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIColor 扩展
 */
@interface UIColor (utility)

/**
 *  从十六进制串转出UIColor对象
 *
 *  @param inColorString 十六进制颜色值
 *  @param alpha         透明度
 *
 *  @return UIColor对象
 */
+ (UIColor*)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha;

@end
