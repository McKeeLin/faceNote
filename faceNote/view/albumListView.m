//
//  albumListView.m
//  faceNote
//
//  Created by 林景隆 on 5/11/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "albumListView.h"
#import "UIImage+blur.h"

@implementation albumListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage blurImage:[UIImage imageNamed:@"effier.jpg"] withRadius:0.01];
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

@end
