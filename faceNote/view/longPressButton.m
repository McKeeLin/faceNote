//
//  longTapButton.m
//  OA
//
//  Created by 林景隆 on 5/26/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "longPressButton.h"

@implementation longPressButton

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


- (void)addLongPressTarget:(id)target selector:(SEL)selector
{
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:lpgr];
    [lpgr release];
}

@end
