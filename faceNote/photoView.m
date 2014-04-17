//
//  photoView.m
//  faceNote
//
//  Created by cdc on 13-11-28.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "photoView.h"
#import "PhotoInfo.h"
#import "dataManager.h"
#import "photoInfoView.h"
#import <QuartzCore/QuartzCore.h>
@interface photoView()
{
    photoInfoView *infoView;
}
@end

@implementation photoView
@synthesize photoPath,info;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame path:(NSString *)path
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.photoPath = path;
        self.autoresizesSubviews = YES;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
        iv.image = [UIImage imageWithContentsOfFile:path];
        iv.layer.cornerRadius = 17;
        iv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:iv];
        [iv release];
        
        self.info = [[dataManager defaultMgr] queryPhotoInfoByPath:path];
        if( info )
        {
            infoView = [[photoInfoView alloc] initWithFrame:frame info:info];
            [self addSubview:infoView];
        }
    }
    return self;
}

- (void)dealloc
{
    [photoPath release];
    [info release];
    [infoView release];
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

@end
