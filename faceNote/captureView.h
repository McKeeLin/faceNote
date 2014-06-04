//
//  captureView.h
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ViewController;

@interface captureView : UIView

@property (retain) ViewController *vc;

@property (assign) PHOTO_TYPE photoType;

- (void)startCapture;

- (void)stopCapture;

- (void)setCameraType:(BOOL)isFront;

@end
