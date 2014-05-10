//
//  indicationView.m
//  faceNote
//
//  Created by 林景隆 on 5/10/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "indicationView.h"

@implementation indicationView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        
        UIImage *buttonImage = [UIImage imageNamed:@"close"];
        CGFloat buttonWidth = buttonImage.size.width;
        CGFloat buttonHeight = buttonImage.size.height;
        CGSize viewSize = self.bounds.size;
        CGRect buttonFrame = CGRectMake(viewSize.width-buttonWidth-10, [UIApplication sharedApplication].statusBarFrame.size.height+10, buttonWidth, buttonHeight);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = buttonFrame;
        [button setImage:buttonImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onTouchClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
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

- (void)onTouchClose:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^(){
        CGRect newFrame = self.bounds;
        self.frame = CGRectOffset(newFrame, self.bounds.size.width, 0);
    }completion:^(BOOL bfinished){
        [self removeFromSuperview];
    }];
}

@end
