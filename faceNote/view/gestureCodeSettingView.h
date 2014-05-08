//
//  gestureCodeSettingView.h
//  OA
//
//  Created by 林景隆 on 14-3-17.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "topbarView.h"

/**
 *  手势密码设置视图委托类
 */
@protocol gestureCodeViewDelegate <NSObject>

/**
 *  手势密码正确时回调
 *
 *  @param gestureCode 手势密码串
 */
- (void)didGestureCodePass:(NSString*)gestureCode;

@end



/**
 *  手势密码设置视图类
 */
@interface gestureCodeSettingView : topbarView

/**
 *  gestureCodeViewDelegate委托对象
 */
@property (weak) id<gestureCodeViewDelegate> delegate;

/**
 *  初始化
 *
 *  @param frame 区域
 *  @param dele  gestureCodeViewDelegate委托对象
 *
 *  @return 该类对象实例
 */
- (id)initWithFrame:(CGRect)frame delegate:(id)dele;

@end
