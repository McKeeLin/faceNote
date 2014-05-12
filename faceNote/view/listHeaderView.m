//
//  listHeaderView.m
//  faceNote
//
//  Created by 林景隆 on 5/11/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "listHeaderView.h"
#import "icloudHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation listHeaderView
@synthesize imageView,portraitButton;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
        
        CGFloat top = 20;
        CGFloat buttonWidth = 100;
        CGFloat buttonHeight = 100;
        CGFloat left = (frame.size.width-buttonWidth)/2;
        portraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        portraitButton.frame = CGRectMake(left, top, buttonWidth, buttonHeight);
        portraitButton.layer.borderWidth = 1.5;
        portraitButton.layer.borderColor = [UIColor whiteColor].CGColor;
        portraitButton.layer.cornerRadius = buttonWidth/2;
        [portraitButton addTarget:self action:@selector(onTouchPortrait:) forControlEvents:UIControlEventTouchUpInside];
        NSString *photoDir = [[icloudHelper helper].appDocumentPath stringByAppendingPathComponent:PHOTO_DIR_NAME];
        NSString *portraitPath = [photoDir stringByAppendingPathComponent:PORTRAIT_FILE_NAME];
        UIImage *image = [UIImage imageWithContentsOfFile:portraitPath];
        if( !image ){
            image = [UIImage imageNamed:@"portrait"];
        }
        [portraitButton setImage:image forState:UIControlStateNormal];
        [self addSubview:portraitButton];
    }
    return self;
}

- (void)dealloc
{
    [imageView release];
    [portraitButton release];
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

- (void)setImage:(UIImage *)image
{
    imageView.image = image;
}

- (void)onTouchPortrait:(id)sender
{
    ;
}

@end
