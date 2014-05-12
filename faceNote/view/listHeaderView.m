//
//  listHeaderView.m
//  faceNote
//
//  Created by 林景隆 on 5/11/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "listHeaderView.h"

@implementation listHeaderView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
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

- (void)setImage:(UIImage *)image
{
    imageView.image = image;
}

@end
