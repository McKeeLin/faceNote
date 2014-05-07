//
//  photoDisplayView.h
//  faceNote
//
//  Created by cdc on 13-11-28.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "pageMgrView.h"

@class ViewController;

@class albumView;

@interface photoDisplayView : pageMgrView

@property (assign) CGPoint point;

@property (retain) ViewController *vc;

@property (assign) albumView *av;

@end
