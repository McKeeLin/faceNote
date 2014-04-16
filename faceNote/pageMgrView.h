//
//  pageMgrView.h
//  faceNote
//
//  Created by cdc on 13-11-5.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 页视图管理类协议
 */
@protocol pageMgrViewDelegate <NSObject>

@optional

/**
 已经显示某一个页
 page: 已显示的页对象
 index: 序号
 */
- (void)didShowPage:(id)page atIndex:(NSInteger)index;

/**
 尝试显示大于最大序号的页
 */
- (void)willOverUpbound;

/**
 尝试显示小于最小序号的页
 */
- (void)willOverLowbound;

@end
 
/**
 具有左右滑动切换子视图的视图类
 */
@interface pageMgrView : UIView

/**
  @param frame 该视图在父视图中的区域
  @param views 子视图列表，UIView成员
  @param index 默认显示的子视图
  @param dele 符合pageMgrViewDelegate的对象
 */
- (id)initWithFrame:(CGRect)frame subViews:(NSArray*)views defaultIndex:(NSInteger)index delegate:(id)dele;

@end
