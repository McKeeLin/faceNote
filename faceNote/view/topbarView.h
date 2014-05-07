//
//  topbarView.h
//  OA
//
//  Created by 林景隆 on 14-3-13.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "baseView.h"

/**
 *  顶部导航视图类
 */
@interface topbarView : baseView

/**
 *  顶部栏视图，iOS7系统中，包括状态栏区域
 */
@property UIView *topbar;

/**
 *  导航区域视图,属tapbar子视图，用于在导航区域添加其他控件，在iOS7系统中不包括状态栏区域
 */
@property UIView *topbarContent;

/**
 *  导航区域之外的视图，用于导航区域之外添加其他控件，
 */
@property UIView *content;

/**
 *  标题
 */
@property UILabel *titleLabel;

/**
 *  返回按钮
 */
@property UIButton *backButton;

/**
 *  导航栏高度
 */
@property CGFloat topbarContentHeight;

@end
