//
//  listHeaderView.m
//  faceNote
//
//  Created by 林景隆 on 5/11/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "listHeaderView.h"
#import "icloudHelper.h"
#import "photoDataMgr.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface listHeaderView()
{
    UIImageView *portraitView;
    UIImageView *bannerView;
}
@end

@implementation listHeaderView
@synthesize bannerButton,portraitButton;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *photoDir = [photoDataMgr manager].photoDir;
        NSFileManager *fm = [NSFileManager defaultManager];
        bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bannerView.layer.contentsGravity = kCAGravityResizeAspectFill;
        NSString *bannerFile = [NSString stringWithFormat:@"%@/%@", photoDir, BANNER_FILE_NAME];
        if( [fm isReadableFileAtPath:bannerFile] )
        {
            UIImage *img = [[photoDataMgr manager] thumbnailImageOfFile:bannerFile maxPixel:MAX(frame.size.width, frame.size.height)];
            bannerView.image = img;
        }
        [self addSubview:bannerView];
        
        bannerButton = [[UIButton alloc] initWithFrame:bannerView.frame];
        [bannerButton addTarget:self action:@selector(onTouchBannerButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bannerButton];
        
        CGFloat top = 20;
        CGFloat buttonWidth = 100;
        CGFloat buttonHeight = 100;
        CGFloat left = (frame.size.width-buttonWidth)/2;
        portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, buttonWidth, buttonHeight)];
        portraitView.layer.contentsGravity = kCAGravityResizeAspectFill;
        portraitView.layer.borderWidth = 1;
        portraitView.layer.borderColor = [UIColor whiteColor].CGColor;
        portraitView.layer.cornerRadius = buttonHeight/2;
        portraitView.layer.masksToBounds = YES;
        NSString *portraitPath = [NSString stringWithFormat:@"%@/%@", photoDir, PORTRAIT_FILE_NAME];
        UIImage *image = nil;
        if( ![fm isReadableFileAtPath:portraitPath] ){
            image = [UIImage imageNamed:@"portrait"];
        }
        else{
            image = [[photoDataMgr manager] thumbnailImageOfFile:portraitPath maxPixel:MAX(buttonWidth, buttonHeight)];
        }
        portraitView.image = image;
        [self addSubview:portraitView];
        
        portraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        portraitButton.frame = portraitView.frame;
        [portraitButton addTarget:self action:@selector(onTouchPortrait:) forControlEvents:UIControlEventTouchUpInside];
        portraitButton.layer.cornerRadius = buttonHeight / 2;
        portraitButton.layer.masksToBounds = YES;
        [self addSubview:portraitButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdatePortraitNotification:) name:UPDATE_PORTRAIT_NOTIFICATION_NAME object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateBannerNotification:) name:UPDATE_BANNER_NOTIFICATION_NAME object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [bannerView release];
    [portraitView release];
    [bannerButton release];
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


- (void)onTouchPortrait:(id)sender
{
    [[ViewController defaultVC] showCameraFromListView];
    [[ViewController defaultVC].cameraView setCameraType:YES];
    [ViewController defaultVC].cameraView.photoType = PHOTO_PORTRAIT;
}

- (void)onTouchBannerButton:(id)sender
{
    [[ViewController defaultVC] showCameraFromListView];
    [[ViewController defaultVC].cameraView setCameraType:NO];
    [ViewController defaultVC].cameraView.photoType = PHOTO_BANNER;
}


- (void)onUpdatePortraitNotification:(NSNotification*)notification
{
    CGFloat max = MAX(portraitButton.frame.size.width, portraitButton.frame.size.height);
    NSString *portraintFile = [NSString stringWithFormat:@"%@/%@", [photoDataMgr manager].photoDir, PORTRAIT_FILE_NAME];
    if( [[NSFileManager defaultManager] isReadableFileAtPath:portraintFile] ){
        UIImage *image = [[photoDataMgr manager] thumbnailImageOfFile:portraintFile maxPixel:max];
        portraitView.image = image;
    }
}

- (void)onUpdateBannerNotification:(NSNotification*)notification
{
    CGFloat max = MAX(bannerButton.frame.size.width, bannerButton.frame.size.height);
    NSString *bannerFile = [NSString stringWithFormat:@"%@/%@", [photoDataMgr manager].photoDir, BANNER_FILE_NAME];
    if( [[NSFileManager defaultManager] isReadableFileAtPath:bannerFile] ){
        UIImage *image = [[photoDataMgr manager] thumbnailImageOfFile:bannerFile maxPixel:max];
        bannerView.image = image;
    }
}

@end
