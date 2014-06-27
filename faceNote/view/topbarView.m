//
//  topbarView.m
//  meetingClound_iPhone
//
//  Created by cdc on 13-12-26.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "topbarView.h"
#import "UIApplication+utility.h"
#import "UIColor+utility.h"

@interface topbarView()

@end

@implementation topbarView
@synthesize topbar,topbarContent,content,titleLabel,backButton,topbarContentHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        topbarContentHeight = 44;
        CGFloat topbarHeight = 44;
        CGFloat topbarContentTop = 0;
        if( [UIApplication systemVersion] >= 7.0 )
        {
            topbarHeight += 20;
            topbarContentTop += 20;
        }
        
        CGRect topbarFrame = CGRectMake(0, 0, self.appSize.width, topbarHeight);
        topbar = [[UIView alloc] initWithFrame:topbarFrame];
        topbar.backgroundColor = UICOLOR(48, 99, 220, 1);
        [self addSubview:topbar];
        
        /*
        UIImageView *topbarBackgroundView = [[UIImageView alloc] initWithFrame:topbarFrame];
        topbarBackgroundView.image = [UIImage imageNamed:@"top_background"];
        topbarBackgroundView.alpha = 0.4;
        [topbar addSubview:topbarBackgroundView];
        */
        
        topbarContent = [[UIView alloc] initWithFrame:CGRectMake(0, topbarContentTop, self.appSize.width, topbarContentHeight)];
        topbarContent.backgroundColor = [UIColor clearColor];
        [topbar addSubview:topbarContent];
        
        CGFloat backButtonWidth = 45;
        CGFloat backButtonHeight = 44;
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(8, 0, backButtonWidth, backButtonHeight);
        [backButton setImage:[UIImage imageNamed:@"backBarItem"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onTouchBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [topbarContent addSubview:backButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(backButtonWidth,
                                                               0,
                                                               self.appSize.width - 2 * backButtonWidth,
                                                               backButtonHeight)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [topbarContent addSubview:titleLabel];
        
        CGRect contentFrame = CGRectMake(0, topbarHeight, self.appSize.width, self.appSize.height - topbarHeight);
        content = [[UIView alloc] initWithFrame:contentFrame];
        [self addSubview:content];
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

- (void)onTouchBackButton:(id)sender
{
    [self dismiss];
}


@end
