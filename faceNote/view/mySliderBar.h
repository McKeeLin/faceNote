//
//  mySliderBar.h
//  OA
//
//  Created by 林景隆 on 5/19/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mySliderBarDelegate  <NSObject>
@optional
- (void)onValueChanged:(CGFloat)newValue;
@end



@interface mySliderBar : UIControl

@property (retain) UIImageView *backgroundImageView;

@property (retain) UIImageView *thumbImageView;

@property CGFloat value;

@property CGFloat maximumValue;

@property CGFloat minimumValue;

@property id<mySliderBarDelegate>delegate;

@property NSInteger calibration;

@property CGFloat rate;

- (id)initWithFrame:(CGRect)frame background:(NSString*)background thumb:(NSString*)thumb vertical:(BOOL)vertical;

- (void)startMovingForIncrease:(BOOL)increase;

- (void)stepForword:(BOOL)bForward;

- (void)stopMove;


@end
