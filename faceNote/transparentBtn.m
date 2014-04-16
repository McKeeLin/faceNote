//
//  transparentBtn.m
//  faceNote
//
//  Created by cdc on 13-11-20.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "transparentBtn.h"
#import <QuartzCore/QuartzCore.h>

@implementation transparentBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target Action:(SEL)selector cornerRadius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if( self )
    {
        UIColor *color = [UIColor colorWithRed:0.00/255.00 green:170.00/255.00 blue:239.00/255.00 alpha:1.0];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
        self.layer.cornerRadius = radius;
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
