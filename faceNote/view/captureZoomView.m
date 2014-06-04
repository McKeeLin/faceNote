//
//  captureZoomView.m
//  OA
//
//  Created by 林景隆 on 5/17/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "captureZoomView.h"
#import "longPressButton.h"

#define ZOOMBUTTON_WIDTH 40
#define ZOOMBUTTON_HEIGHT 40
#import "mySliderBar.h"

@interface captureZoomView()<mySliderBarDelegate>
{
    CGFloat pinScale;
    NSInteger maxZoom;
    NSInteger minZoom;
    CGFloat lastZoom;
    longPressButton *zoomInButton; //放大按钮
    longPressButton *zoomOutButton;
    mySliderBar *slider;
    UISlider *sl;
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
        maxZoom = 10;
        minZoom = 1;
        lastZoom = 1;
        if( [UIDevice currentDevice].systemVersion.floatValue >= 7.0 ){
            if( [camera respondsToSelector:@selector(videoMaxZoomFactor)] )
            {
                maxZoom = [camera videoMaxZoomFactor];
                NSLog(@"max zoom:%d",maxZoom);
            }
        }
        /*
        UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinGesture:)];
        [self addGestureRecognizer:pgr];
        [pgr release];
        */
        
        CGFloat buttonMargin = 7;
        CGRect buttonFrame = CGRectMake(buttonMargin, frame.size.height-buttonMargin-ZOOMBUTTON_HEIGHT, ZOOMBUTTON_WIDTH, ZOOMBUTTON_HEIGHT);
        zoomInButton = [longPressButton buttonWithType:UIButtonTypeCustom];
        zoomInButton.frame = buttonFrame;
        [zoomInButton setTitle:@"+" forState:UIControlStateNormal];
        [zoomInButton addTarget:self action:@selector(onZoomInButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
//        [zoomInButton addLongPressTarget:self selector:@selector(onZoomInLongPress:)];
        [self addSubview:zoomInButton];
        
        CGFloat sliderWidth = 13;
        CGFloat sliderHeight = 250;
        CGFloat sliderTop = (frame.size.height-sliderHeight)/2;
        CGFloat sliderLeft = frame.size.width - 13 - 10;
        CGRect sliderFrame = CGRectMake(sliderLeft, sliderTop, sliderWidth, sliderHeight);
        slider = [[mySliderBar alloc] initWithFrame:sliderFrame background:@"" thumb:@"thumb" vertical:YES];
        slider.delegate = self;
        slider.maximumValue = maxZoom;
        slider.minimumValue = minZoom;
        slider.maximumLabel.text = [NSString stringWithFormat:@"%d", maxZoom];
        slider.minimumLabel.text = [NSString stringWithFormat:@"%d", minZoom];
        slider.rate = slider.maximumValue / 3;
        slider.calibration = maxZoom-minZoom;
        [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        
        /*
        sliderFrame = CGRectMake(10, 100, 100, 100);
        sl = [[UISlider alloc] initWithFrame:sliderFrame];
        sl.thumbTintColor = [UIColor yellowColor];
        sl.maximumTrackTintColor = [UIColor orangeColor];
        sl.minimumTrackTintColor = [UIColor orangeColor];
        sl.userInteractionEnabled = NO;
        sl.maximumValue = maxZoom;
        sl.minimumValue = minZoom;
        [sl setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
        [self addSubview:sl];
        */
        
        buttonFrame.origin.x = frame.size.width - ZOOMBUTTON_WIDTH - buttonMargin;
        zoomOutButton = [longPressButton buttonWithType:UIButtonTypeCustom];
        zoomOutButton.frame = buttonFrame;
        [zoomOutButton setTitle:@"-" forState:UIControlStateNormal];
        [zoomOutButton addTarget:self action:@selector(onZoomOutButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
//        [zoomOutButton addLongPressTarget:self selector:@selector(onZoomOutLongPress:)];
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
        const CGFloat kMaxScale = 20.0;
        const CGFloat kMinScale = 1.0;
        
        CGFloat newScale = 1 - (pinScale - [pgr scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
//        NSLog(@"%s,pinScale:%f, currentScale:%f, newscale:%f, pgr scale:%f", __func__, pinScale, currentScale, newScale, pgr.scale);
       
        float curZoom = [camera videoZoomFactor];
        curZoom = lastZoom;
        CGFloat newZoom = 1 - (pinScale - [pgr scale]);
        newZoom = MIN(newZoom, maxZoom / curZoom );
        newZoom = MAX(newZoom, minZoom / curZoom );
//        newZoom = newZoom + curZoom;
        
        CGFloat velocity = pgr.velocity;
        if( velocity == 0 ) return;
        
        CGFloat t = (currentScale-pinScale)/velocity;
        if( t == 0 )return;
        
//        if( t < 0 ) t = t * (-1);
        float factor = t * slider.rate * 2;// t * velocity * 4;
        if( currentScale > pinScale )
        {
            newZoom = curZoom + factor;
        }
        else{
            newZoom = curZoom - factor;
        }
        newZoom = curZoom * currentScale;
        if( newZoom > maxZoom ) newZoom = maxZoom;
        if( newZoom < minZoom ) newZoom = minZoom;
        
        CGFloat rate = (newZoom - curZoom) / t;
        NSLog(@" time:%f, lastScale:%f, currentScale:%f, velocity:%f, factor:%f, currentZoom:%f, newZoom:%f, rate:%f", t, pinScale, currentScale, velocity, factor, curZoom, newZoom,rate);
        [self setNewZoom:newZoom rate:rate];
        slider.value = newZoom;
        pinScale = currentScale;  // Store the previous scale factor for the next pinch gesture call
        lastZoom = newZoom;
    }
    else if( pgr.state == UIGestureRecognizerStateEnded || pgr.state == UIGestureRecognizerStateCancelled ){
        [self stopZoom];
    }
}

- (void)onZoomInButtonTouchUp:(id)sender
{
    NSLog(@"%s", __func__);
    [slider stepForword:YES];
    [self setNewZoom:slider.value rate:2.0];
}

- (void)onZoomOutButtonTouchUp:(id)sender
{
    NSLog(@"%s", __func__);
    [slider stepForword:NO];
    [self setNewZoom:slider.value rate:2.0];
}

- (void)onValueChanged:(CGFloat)newValue
{
    NSLog(@"%s,%f", __func__,newValue);
//    [self setNewZoom:newValue];
}


- (void)onZoomInLongPress:(id)sender
{
    NSLog(@"%s", __func__);
    UILongPressGestureRecognizer *lpgr = (UILongPressGestureRecognizer*)sender;
    if( lpgr.state == UIGestureRecognizerStateBegan )
    {
        [slider startMovingForIncrease:YES];
    }
    else if( lpgr.state == UIGestureRecognizerStateEnded ){
        [slider stopMove];
    }
}

- (void)onZoomOutLongPress:(id)sender
{
    NSLog(@"%s", __func__);
    UILongPressGestureRecognizer *lpgr = (UILongPressGestureRecognizer*)sender;
    if( lpgr.state == UIGestureRecognizerStateBegan )
    {
        [slider startMovingForIncrease:NO];
    }
    else if( lpgr.state == UIGestureRecognizerStateEnded ){
        [slider stopMove];
    }
}

- (void)setNewZoom:(CGFloat)zoom rate:(CGFloat)rate
{
    NSLog(@"%s, zoom:%f, rate:%f", __func__, zoom, rate);
    NSError *err = nil;
    if( [camera lockForConfiguration:&err] ){
        [camera rampToVideoZoomFactor:zoom withRate:rate];
        [camera unlockForConfiguration];
    }
}

- (void)stopZoom
{
    NSError *err = nil;
    if( [camera lockForConfiguration:&err] ){
        [camera cancelVideoZoomRamp];
        [camera unlockForConfiguration];
    }
}

- (void)onSliderValueChanged:(id)sender
{
    NSLog(@"%s,...%f", __func__, slider.value);
}

@end
