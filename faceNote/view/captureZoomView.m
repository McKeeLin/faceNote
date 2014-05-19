//
//  captureZoomView.m
//  OA
//
//  Created by 林景隆 on 5/17/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "captureZoomView.h"

#define ZOOMBUTTON_WIDTH 16
#define ZOOMBUTTON_HEIGHT 16
#import "mySliderBar.h"

@interface captureZoomView()<mySliderBarDelegate>
{
    CGFloat pinScale;
    CGFloat maxZoom;
    CGFloat minZoom;
    UIButton *zoomInButton; //放大按钮
    UIButton *zoomOutButton;
    mySliderBar *slider;
}

@end

@implementation captureZoomView
@synthesize camera;

- (id)initWithFrame:(CGRect)frame camera:(AVCaptureDevice*)device
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.camera = device;
        maxZoom = 10.0;
        minZoom = 1.0;
        if( [UIDevice currentDevice].systemVersion.floatValue >= 7.0 ){
            if( [camera respondsToSelector:@selector(videoMaxZoomFactor)] )
            {
                maxZoom = [camera videoMaxZoomFactor];
                NSLog(@"max zoom:%f",maxZoom);
            }
            UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinGesture:)];
            [self addGestureRecognizer:pgr];
            [pgr release];
        }
        
        CGFloat buttonMargin = 7;
        CGRect buttonFrame = CGRectMake(buttonMargin, frame.size.height-buttonMargin-ZOOMBUTTON_HEIGHT, ZOOMBUTTON_WIDTH, ZOOMBUTTON_HEIGHT);
        zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomInButton.frame = buttonFrame;
        [zoomInButton setTitle:@"+" forState:UIControlStateNormal];
        [zoomInButton addTarget:self action:@selector(onZoomInButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [zoomInButton addTarget:self action:@selector(onZoomInButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zoomInButton];
        
        CGRect sliderFrame = CGRectMake(20, buttonFrame.origin.y+5, 100, 5);
        slider = [[mySliderBar alloc] initWithFrame:sliderFrame background:@"" thumb:@"thumb"];
        slider.delegate = self;
        slider.maximumValue = 10;
        slider.minimumValue = 1;
        [self addSubview:slider];
        
        buttonFrame.origin.x = frame.size.width - ZOOMBUTTON_WIDTH - buttonMargin;
        zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomOutButton.frame = buttonFrame;
        [zoomOutButton setTitle:@"-" forState:UIControlStateNormal];
        [zoomOutButton addTarget:self action:@selector(onZoomOutButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [zoomOutButton addTarget:self action:@selector(onZoomInButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zoomOutButton];
    }
    return self;
}

- (void)dealloc
{
    [camera release];
    [zoomInButton release];
    [zoomOutButton release];
    [slider release];
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


- (void)onPinGesture:(UIPinchGestureRecognizer*)pgr
{
    if([pgr state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        pinScale = [pgr scale];
    }
    
    if ([pgr state] == UIGestureRecognizerStateBegan ||
        [pgr state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"pgr scale:%f", pgr.scale);
        CGFloat currentScale = pgr.scale;
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 10.0;
        const CGFloat kMinScale = 1.0;
        
        CGFloat newScale = 1 - (pinScale - [pgr scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
//        NSLog(@"%s,pinScale:%f, currentScale:%f, newscale:%f, pgr scale:%f", __func__, pinScale, currentScale, newScale, pgr.scale);
       
        float curZoom = [camera videoZoomFactor];
//        NSLog(@"%s, currentZoom:%f", __func__, curZoom);
        if( curZoom < 1.0 ){
            curZoom = 1.0;
        }
        CGFloat newZoom = 1 - (pinScale - [pgr scale]);
        newZoom = MIN(newZoom, maxZoom / curZoom );
        newZoom = MAX(newZoom, minZoom / curZoom );
//        newZoom = newZoom + curZoom;
        
        CGFloat velocity = pgr.velocity;
        CGFloat t = (pgr.scale-pinScale)/velocity;
//        if( t < 0 ) t = t * (-1);
        float factor = t * velocity * 4;
        if( currentScale > pinScale )
        {
            newZoom = curZoom + factor;
        }
        else{
            newZoom = curZoom - factor;
        }
        newZoom = curZoom + factor;
        if( newZoom > maxZoom ) newZoom = maxZoom;
        if( newZoom < minZoom ) newZoom = minZoom;
        NSLog(@"%s, time:%f, lastScale:%f, currentScale:%f, velocity:%f, factor:%f, currentZoom:%f, newZoom:%f", __func__, t, pinScale, currentScale, velocity, factor, curZoom, newZoom);
        NSError *err = nil;
        if( [camera lockForConfiguration:&err] ){
            [camera rampToVideoZoomFactor:newZoom withRate:pgr.velocity];
            [camera unlockForConfiguration];
        }
        else{
//            NSLog(@"%s, lockForConfiguration failed:%@", __func__, err.localizedDescription);
        }
        pinScale = currentScale;  // Store the previous scale factor for the next pinch gesture call
        
    }
}

- (void)onZoomInButtonTouchDown:(id)sender
{
    NSLog(@"%s", __func__);
    [slider startMovingForIncrease:YES inTime:5];
}

- (void)onZoomInButtonTouchUp:(id)sender
{
    NSLog(@"%s", __func__);
    [slider stopMove];
}

- (void)onZoomOutButtonTouchDown:(id)sender
{
    NSLog(@"%s", __func__);
    [slider startMovingForIncrease:NO inTime:5];
}

- (void)onZoomOutButtonTouchUp:(id)sender
{
    NSLog(@"%s", __func__);
    [slider stopMove];
}

- (void)onValueChanged:(CGFloat)newValue
{
    NSLog(@"%s", __func__);
    ;
}

@end
