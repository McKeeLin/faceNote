//
//  mySliderBar.m
//  OA
//
//  Created by 林景隆 on 5/19/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "mySliderBar.h"
#import <QuartzCore/QuartzCore.h>

@interface mySliderBar()
{
    CATransition *transition;
    NSInteger calibration;
    CGFloat _value;
    CGSize thumbSize;
    BOOL bVertical;
}
@end

@implementation mySliderBar
@synthesize backgroundImageView,thumbImageView,maximumValue,minimumValue,delegate,rate;

- (id)initWithFrame:(CGRect)frame background:(NSString *)background thumb:(NSString *)thumb vertical:(BOOL)vertical
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _value = 0.0;
        bVertical = vertical;
        
        UIImage *thumbImage = [UIImage imageNamed:thumb];
        if( thumb ){
            thumbSize = thumbImage.size;
            CGRect backgroundFrame = self.bounds;
            backgroundFrame.size.width -= thumbSize.width;
            backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self addSubview:backgroundImageView];
            
            CGRect thumbFrame = CGRectZero;
            if( !vertical ){
                thumbFrame = CGRectMake(0, (frame.size.height-thumbSize.height)/2, thumbSize.width, thumbSize.height);
            }
            else{
                thumbFrame = CGRectMake((frame.size.width-thumbSize.width)/2, 0, thumbSize.width, thumbSize.height);
            }
            thumbImageView = [[UIImageView alloc] initWithFrame:thumbFrame];
            thumbImageView.image = thumbImage;
            [self addSubview:thumbImageView];
//            [thumbImageView.layer addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self forKeyPath:@"thumbImageView.layer.frame" options:NSKeyValueObservingOptionNew context:nil];
            
            calibration = 10;
        }
    }
    return self;
}

- (void)dealloc
{
    [backgroundImageView release];
    [thumbImageView release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setValue:(CGFloat)value
{
    _value = value;
    CGFloat x = (value/maximumValue)*backgroundImageView.frame.size.width;
    CGRect thumbFrame = thumbImageView.frame;
    thumbFrame.origin.x = x;
    thumbImageView.frame = thumbFrame;
}

- (CGFloat)value
{
    return _value;
}

- (void)startMovingForIncrease:(BOOL)increase
{
    NSLog(@"%s", __func__);
    CGRect finalFrame;
    CGRect thumbFrame = thumbImageView.frame;
    CGRect backgroundFrame = backgroundImageView.frame;
    finalFrame = thumbFrame;
    if( !bVertical ){
        if( increase ){
            finalFrame.origin.x = backgroundFrame.size.width;
        }
        else{
            finalFrame.origin.x = 0;
        }
    }
    else{
        if( increase ){
            finalFrame.origin.y = backgroundFrame.size.height;
        }
        else{
            finalFrame.origin.y = 0;
        }
    }
    
    CGFloat totalTime = (maximumValue - minimumValue) / rate;
    CGFloat duration = totalTime;
    if( duration < 0 ){
        duration = -1 *duration;
    }
    NSLog(@"%s, duration:%f",__func__, duration);
    [UIView animateWithDuration:duration animations:^(){
        thumbImageView.frame = finalFrame;
    }];
    /*
    CGRect curFrame = thumbImageView.layer.frame;
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"frame"];
    an.fromValue = [NSValue valueWithCGRect:curFrame];
    an.toValue = [NSValue valueWithCGRect:finalFrame];
    an.duration = duration;
    an.delegate = self;
    [thumbImageView.layer addAnimation:an forKey:@""];
    */
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"%s", __func__);
    CALayer *layer = thumbImageView.layer.presentationLayer;
//    [layer addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"%s", __func__);
    CALayer *layer = thumbImageView.layer.presentationLayer;
//    [layer removeObserver:self forKeyPath:@"frame"];
}

- (void)stepForword:(BOOL)bForward
{
    CGFloat duration = 3;
    CGRect finalFrame = thumbImageView.frame;
    if( !bVertical ){
        CGFloat stepWidth = backgroundImageView.frame.size.width/calibration;
       if( bForward ){
            finalFrame.origin.x += stepWidth;
            if( finalFrame.origin.x > backgroundImageView.frame.size.width - thumbSize.width ){
                finalFrame.origin.x = backgroundImageView.frame.size.width - thumbSize.width;
            }
        }
        else{
            finalFrame.origin.x -= stepWidth;
            if( finalFrame.origin.x < 0 ){
                finalFrame.origin.x = 0;
            }
        }
        duration = stepWidth / rate;
    }
    else{
        CGFloat stepHeight = backgroundImageView.frame.size.height/calibration;
        if( bForward ){
            finalFrame.origin.y += stepHeight;
            if( finalFrame.origin.y > backgroundImageView.frame.size.height - thumbSize.height )
            {
                finalFrame.origin.y = backgroundImageView.frame.size.height - thumbSize.height;
            }
        }
        else{
            finalFrame.origin.y -= stepHeight;
            if( finalFrame.origin.y < 0 ){
                finalFrame.origin.y = 0;
            }
        }
    }
    
    [UIView animateWithDuration:duration animations:^(){
        thumbImageView.frame = finalFrame;
    }];
}

- (void)stopMove
{
    NSLog(@"%s", __func__);
    CALayer *presentationLayer = thumbImageView.layer.presentationLayer;
    thumbImageView.layer.frame = presentationLayer.frame;
    [thumbImageView.layer removeAllAnimations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%s", __func__);
    NSNumber *number = nil;
    NSValue *newValue = [change objectForKey:NSKeyValueChangeNewKey];
    CGRect newFrame = [newValue CGRectValue];
    if( delegate && [delegate respondsToSelector:@selector(onValueChanged:)] ){
        _value = (newFrame.origin.x / backgroundImageView.frame.size.width)*maximumValue;
        NSLog(@"%s, number:%f, new value:%f", __func__, newFrame.origin.x, _value);
        [delegate onValueChanged:_value];
    }
}

@end
