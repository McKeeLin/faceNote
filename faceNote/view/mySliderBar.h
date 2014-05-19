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



@interface mySliderBar : UIView

@property (retain) UIImageView *backgroundImageView;

@property (retain) UIImageView *thumbImageView;

@property CGFloat currentValue;

@property CGFloat maximumValue;

@property CGFloat minimumValue;

@property id<mySliderBarDelegate>delegate;

- (id)initWithFrame:(CGRect)frame background:(NSString*)background thumb:(NSString*)thumb;

- (void)startMovingForIncrease:(BOOL)increase inTime:(NSInteger)seconds;

- (void)stopMove;


@end
