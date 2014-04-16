//
//  listToolBar.m
//  faceNote
//
//  Created by cdc on 13-12-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "listToolBar.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "transparentBtn.h"

@implementation listToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        CGFloat buttonWidth = 33;
        CGFloat buttonHeight = 33;
        CGFloat left = ( frame.size.width - buttonWidth ) / 2;
        CGFloat top = ( frame.size.height - buttonHeight ) / 2;
        CGRect buttonFrame = CGRectMake(left, top, buttonWidth, buttonHeight);
        transparentBtn *cameraButton = [[transparentBtn alloc] initWithFrame:buttonFrame title:@"" target:self Action:@selector(onTouchCameraButton:) cornerRadius:5];
        UIImage *img = [UIImage imageNamed:@"camera"];
        [cameraButton setImage:img forState:UIControlStateNormal];
        /*
        cameraButton.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
        [cameraButton addTarget:self action:@selector(onTouchCameraButton:) forControlEvents:UIControlEventTouchDown];
        */
        [self addSubview:cameraButton];
        [cameraButton release];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)onTouchCameraButton:(id)sender
{
    [[ViewController defaultVC] showCameraFromListView];
}

@end
