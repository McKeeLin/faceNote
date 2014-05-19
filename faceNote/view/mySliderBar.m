//
//  mySliderBar.m
//  OA
//
//  Created by 林景隆 on 5/19/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "mySliderBar.h"

@interface mySliderBar()
{
    CATransition *transition;
}
@end

@implementation mySliderBar
@synthesize backgroundImageView,thumbImageView,currentValue,maximumValue,minimumValue,delegate;

- (id)initWithFrame:(CGRect)frame background:(NSString *)background thumb:(NSString *)thumb
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentValue = 0.0;
        
        UIImage *thumbImage = [UIImage imageNamed:thumb];
        if( thumb ){
            CGSize size = thumbImage.size;
            CGRect backgroundFrame = self.bounds;
            backgroundFrame.size.width -= size.width;
            backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self addSubview:backgroundImageView];
            
            CGRect thumbFrame = CGRectMake(0, 0, size.width, size.height);
            thumbImageView = [[UIImageView alloc] initWithFrame:thumbFrame];
            thumbImageView.image = thumbImage;
            [self addSubview:thumbImageView];
            
            [thumbImageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
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

- (void)startMovingForIncrease:(BOOL)increase inTime:(NSInteger)seconds
{
    NSLog(@"%s", __func__);
    /*
    [UIView animateWithDuration:seconds animations:^(){
    }];
    */
    CGRect finalFrame;
    CGRect thumbFrame = thumbImageView.frame;
    CGRect backgroundFrame = backgroundImageView.frame;
    finalFrame = thumbFrame;
    if( increase ){
        finalFrame.origin.x = backgroundFrame.size.width;
    }
    else{
        finalFrame.origin.x = 0;
    }
//    thumbImageView.frame = finalFrame;
    
    CABasicAnimation *an = [[CABasicAnimation alloc] init];
    an.keyPath = @"frame";
    an.fromValue = [NSValue valueWithCGRect:thumbFrame];
    an.toValue = [NSValue valueWithCGRect:finalFrame];
    an.duration = seconds;
    an.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [thumbImageView.layer addAnimation:an forKey:@""];
}

- (void)stopMove
{
    NSLog(@"%s", __func__);
    [self.layer removeAllAnimations];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%s", __func__);
    NSNumber *number = nil;
    NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];
    CGRect newFrame = [value CGRectValue];
    if( delegate && [delegate respondsToSelector:@selector(onValueChanged:)] ){
        currentValue = (newFrame.origin.x / backgroundImageView.frame.size.width)*maximumValue;
        NSLog(@"%s, number:%f, new value:%f", __func__, newFrame.origin.x, currentValue);
        [delegate onValueChanged:currentValue];
    }
}

@end
