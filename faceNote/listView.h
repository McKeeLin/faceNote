//
//  listView.h
//  faceNote
//
//  Created by cdc on 13-11-6.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface listView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (retain) ViewController *vc;

- (void)loadImages;

@end
