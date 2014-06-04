//
//  captureZoomView.h
//  OA
//
//  Created by 林景隆 on 5/17/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface captureZoomView : UIView
{
}

@property (retain) AVCaptureDevice *camera;


- (id)initWithFrame:(CGRect)frame camera:(AVCaptureDevice*)device;

@end
