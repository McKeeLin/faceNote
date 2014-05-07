//
//  albumView.h
//  faceNote
//
//  Created by cdc on 13-11-23.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "album.h"

#define ALBUMVIEW_DEFAULT_HEIGHT 150

@interface albumView : UIView

@property NSInteger albumHeight;

- (id)initWithFrame:(CGRect)frame album:(album*)am;

- (void)relayout;

@end
