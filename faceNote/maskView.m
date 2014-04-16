//
//  maskView.m
//  faceNote
//
//  Created by cdc on 14-1-5.
//  Copyright (c) 2014年 cndatacom. All rights reserved.
//

#import "maskView.h"
#import <QuartzCore/QuartzCore.h>

@implementation maskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.backgroundColor = [UIColor blueColor];
        btn.frame = CGRectMake(80, frame.size.height - 50, 100, 50);
        [self addSubview:btn];
    }
    
    CALayer *layer = self.layer;
    NSArray *sublayers = layer.sublayers;
    NSArray *subViews = self.subviews;
    return self;
}

//*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img = [UIImage imageNamed:@"title_bg"];
    [img drawInRect:rect];
}
//*/

@end
