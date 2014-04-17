//
//  UIApplication+utility.h
//  OA
//
//  Created by 林景隆 on 14-3-2.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIApplication扩展类
 */
@interface UIApplication (utility)

/**
 *  获取系统版本号
 *
 *  @return 系统版本号
 */
+ (CGFloat)systemVersion;

/**
 *  获取当前设备屏幕方向下的宽、高
 *
 *  @return 宽高
 */
+ (CGSize)appSize;

@end
