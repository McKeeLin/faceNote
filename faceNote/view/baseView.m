//
//  baseView.m
//  meetingClound_iPhone
//
//  Created by cdc on 13-12-26.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "baseView.h"
#import "UIApplication+utility.h"

@implementation baseView
@synthesize appSize,bgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
        appSize = [UIApplication appSize];
        /*
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, appSize.width, appSize.height)];
        bgView.image = [UIImage imageNamed:@"backgroundImage.png"];
        [self addSubview:bgView];
        */
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


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if( newSuperview ){
        CGRect finalFrame = self.frame;
        self.frame = CGRectOffset(self.frame, self.frame.size.width, 0);
        [UIView animateWithDuration:0.25 animations:^(){
            self.frame = finalFrame;
        }completion:^(BOOL bfinished){
            ;
        }];
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^(){
        CGRect newFrame = self.bounds;
        self.frame = CGRectOffset(newFrame, self.bounds.size.width, 0);
    }completion:^(BOOL bfinished){
        [self removeFromSuperview];
    }];
}



@end
