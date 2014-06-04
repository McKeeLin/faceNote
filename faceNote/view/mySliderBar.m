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
@synthesize backgroundImageView,thumbImageView,maximumValue,minimumValue,delegate,rate,maximumLabel,minimumLabel,line;

- (id)initWithFrame:(CGRect)frame background:(NSString *)background thumb:(NSString *)thumb vertical:(BOOL)vertical
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _value = 1.0;
        bVertical = vertical;
        CGFloat labelWidth = 15;
        CGFloat labelHeight = 12;
        CGFloat labelMargin = 5;
        CGFloat frameWidth = frame.size.width;
        CGFloat frameHeight = frame.size.height;
        CGRect backgroundFrame = self.bounds;
        CGRect maximumLabelFrame = CGRectZero;
        CGRect minimumLabelFrame = CGRectZero;
        CGRect thumbFrame = CGRectZero;
        CGRect lineFrame = CGRectZero;
        
        UIImage *thumbImage = [UIImage imageNamed:thumb];
        if( thumb ){
            thumbSize = thumbImage.size;
            if( vertical ){
                minimumLabelFrame = CGRectMake((frameWidth-labelWidth)/2, 0, labelWidth, labelHeight);
                maximumLabelFrame = CGRectMake((frameWidth-labelWidth)/2, frameHeight-labelHeight, labelWidth, labelHeight);
                backgroundFrame = CGRectMake(0, labelHeight+labelMargin, frameWidth, frameHeight-2*labelMargin-2*labelHeight);
                thumbFrame = CGRectMake((frameWidth-thumbSize.width)/2, backgroundFrame.origin.y, thumbSize.width, thumbSize.height);
                lineFrame = CGRectMake((frameWidth-1)/2, labelHeight+labelMargin, 1, frameHeight-2*labelMargin-2*labelHeight);
            }
            else{
                minimumLabelFrame = CGRectMake(0, (frameHeight-labelHeight)/2, labelWidth, labelHeight);
                maximumLabelFrame = CGRectMake(frameWidth-labelWidth, (frameHeight-labelHeight)/2, labelWidth, labelHeight);
                backgroundFrame = CGRectMake(labelWidth+labelMargin, 0, frameWidth-2*labelMargin-2*labelWidth, frameHeight);
                thumbFrame = CGRectMake(backgroundFrame.origin.x, (frameHeight-thumbSize.height)/2, thumbSize.width, thumbSize.height);
                lineFrame = CGRectMake(labelMargin+labelWidth, (frameHeight-1)/2, frameWidth-2*labelWidth-2*labelMargin, 1);
            }
            
            maximumLabel = [[UILabel alloc] initWithFrame:maximumLabelFrame];
            maximumLabel.text = [NSString stringWithFormat:@"%f", maximumValue];
            maximumLabel.textColor = [UIColor whiteColor];
            maximumLabel.font = [UIFont systemFontOfSize:12];
            minimumLabel.textAlignment = NSTextAlignmentCenter;
            maximumLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:maximumLabel];
            
            minimumLabel = [[UILabel alloc] initWithFrame:minimumLabelFrame];
            minimumLabel.text = [NSString stringWithFormat:@"%f", minimumValue];
            minimumLabel.textColor = [UIColor whiteColor];
            minimumLabel.font = [UIFont systemFontOfSize:12];
            minimumLabel.textAlignment = NSTextAlignmentCenter;
            minimumLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:minimumLabel];
            
            backgroundImageView = [[UIImageView alloc] initWithFrame:backgroundFrame];
            [self addSubview:backgroundImageView];
            
            line = [[UIView alloc] initWithFrame:lineFrame];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
            
            thumbImageView = [[UIImageView alloc] initWithFrame:thumbFrame];
            thumbImageView.image = thumbImage;
            [self addSubview:thumbImageView];
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
    CGFloat duration = 0.3;
    CGFloat step = maximumValue / calibration;
    CGRect finalFrame = thumbImageView.frame;
    if( !bVertical ){
        CGFloat stepWidth = line.frame.size.width/calibration;
       if( bForward ){
            finalFrame.origin.x += stepWidth;
            if( finalFrame.origin.x > line.frame.origin.x + line.frame.size.width - thumbSize.width ){
                finalFrame.origin.x = line.frame.origin.x + line.frame.size.width - thumbSize.width;
            }
        }
        else{
            finalFrame.origin.x -= stepWidth;
            if( finalFrame.origin.x < line.frame.origin.x ){
                finalFrame.origin.x = line.frame.origin.x;
            }
        }
    }
    else{
        CGFloat stepHeight = line.frame.size.height/calibration;
        if( bForward ){
            finalFrame.origin.y += stepHeight;
            if( finalFrame.origin.y > line.frame.origin.y + line.frame.size.height - thumbSize.height )
            {
                finalFrame.origin.y = line.frame.origin.y + line.frame.size.height - thumbSize.height;
            }
        }
        else{
            finalFrame.origin.y -= stepHeight;
            if( finalFrame.origin.y < line.frame.origin.y ){
                finalFrame.origin.y = line.frame.origin.y;
            }
        }
    }
    
    if( bForward ){
        _value += step;
    }
    else{
        _value -= step;
    }
    
    if( _value > maximumValue ){
        _value = maximumValue;
    }
    if( _value < minimumValue ){
        _value = minimumValue;
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
