//
//  captureView.m
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "captureView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreVideo/CVPixelBuffer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "def.h"
#import "transparentBtn.h"
#import "UIApplication+appSize.h"
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "locationMgr.h"
#import "titleValueView.h"
#import "dataManager.h"
#import "PhotoInfo.h"
#import "maskView.h"

@interface captureView()<AVCaptureAudioDataOutputSampleBufferDelegate>
{
    BOOL isFrontCamera;
    titleValueView *latitude;
    titleValueView *longitude;
    titleValueView *altitude;
    titleValueView *contry;
    titleValueView *administrativeArea;
    titleValueView *locality;
    titleValueView *subLocality;
    titleValueView *thoroughfare;
    titleValueView *subThoroughfare;
}

@property (retain) AVCaptureDevice *camera;
@property (retain) AVCaptureSession *session;
@property (retain) AVCaptureStillImageOutput *imageOut;
@property (retain) transparentBtn *captureButton;
@property (retain) transparentBtn *toggleCameraButton;
@property (retain) transparentBtn *toggleCloseButton;
@property (retain) UIView *frontView;
@property (retain) UIView *backView;
@property (retain) NSString *documentPath;
@property (retain) AVCaptureVideoPreviewLayer *cameraLayer;

@end

@implementation captureView
@synthesize camera,cameraLayer,session,captureButton,toggleCloseButton,toggleCameraButton,frontView,backView,imageOut,documentPath,vc;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *gr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSlideToRight:)];
        gr.direction = UISwipeGestureRecognizerDirectionRight;
        gr.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:gr];
        [gr release];
        
        UISwipeGestureRecognizer *sdgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSlideDown:)];
        sdgr.direction = UISwipeGestureRecognizerDirectionDown;
        sdgr.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:sdgr];
        [sdgr release];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentPath = [paths objectAtIndex:0];
        
        frontView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:frontView];
        
        backView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:backView];
        
        CGFloat buttonWidth = 80;
        CGFloat buttonHeight = 30;
        CGFloat internalWidth =( frame.size.width - 240 ) / 2;
        CGFloat top = frame.size.height - buttonHeight - 15;
        CGFloat left = 0;
        CGRect buttonFrame = CGRectMake(left, top, buttonWidth, buttonHeight);
        /*
        self.toggleCameraButton = [[transparentBtn alloc] initWithFrame:buttonFrame title:@"toggle" target:self Action:@selector(onTouchToggleClose:) cornerRadius:5];
        [self addSubview:toggleCameraButton];
        */
        
        buttonFrame.origin.x += buttonWidth + internalWidth;
        CGRect captureButtonFrame = buttonFrame;
        captureButtonFrame.origin.y = frame.size.height - buttonWidth - 5;
        captureButtonFrame.size.height = buttonWidth;
        self.captureButton = [[transparentBtn alloc] initWithFrame:captureButtonFrame title:@"capture" target:self Action:@selector(onTouchCapture:) cornerRadius:buttonWidth/2];
        [self addSubview:captureButton];
        
        /*
        buttonFrame.origin.x += buttonWidth + internalWidth;
        self.toggleCloseButton = [[transparentBtn alloc] initWithFrame:buttonFrame title:@"I/O" target:self Action:@selector(onTouchToggleCamera:) cornerRadius:5];
        [self addSubview:toggleCloseButton];
        */
        
        [self setCameraType:NO];
        if( self.camera )
        {
            session = [[AVCaptureSession alloc] init];
            [self initCamera];
            [self startCapture];
            
        }
        
        CGRect maskFrame = self.bounds;
        maskFrame.size.height = 500;
        maskView *mask = [[maskView alloc] initWithFrame:maskFrame];
        [self addSubview:mask];
        [[locationMgr defaultMgr] addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [contry release];
    [administrativeArea release];
    [locality release];
    [subLocality release];
    [thoroughfare release];
    [subThoroughfare release];
    [toggleCameraButton release];
    [captureButton release];
    [toggleCloseButton release];
    [frontView release];
    [camera release];
    [session release];
    [imageOut release];
    [documentPath release];
    [vc release];
    [cameraLayer release];
    [latitude release];
    [longitude release];
    [altitude release];
    [contry release];
    [administrativeArea release];
    [locality release];
    [subLocality release];
    [thoroughfare release];
    [subThoroughfare release];
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

- (void)setCameraType:(BOOL)isFront
{
    isFrontCamera = isFront;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for( AVCaptureDevice *device in devices )
    {
        if( isFront )
        {
            if( device.position == AVCaptureDevicePositionFront )
            {
                self.camera = device;
                break;
            }
        }
        else
        {
            if( device.position == AVCaptureDevicePositionBack )
            {
                self.camera = device;
                break;
            }
        }
    }
    
}

- (void)initCamera
{
    CGRect bounds = self.frame;    
    // session addinput
    NSError *err = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.camera error:&err];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    [self.session addInput:input];
    
    // session addoutput
    /*
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] initWithCapacity:0];
    [setting setObject:[NSNumber numberWithFloat:appWidth] forKey:(id)kCVPixelBufferWidthKey];
    [setting setObject:[NSNumber numberWithFloat:appHeight] forKey:(id)kCVPixelBufferHeightKey];
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    output.videoSettings = setting;
    [self.session addOutput:output];
    [output release];
    */
    
    imageOut = [[AVCaptureStillImageOutput alloc] init];
    NSMutableDictionary *imageOutputSetting = [NSMutableDictionary dictionaryWithCapacity:0];
    [imageOutputSetting setObject:[NSNumber numberWithFloat:appWidth] forKey:(id)kCVPixelBufferWidthKey];
    [imageOutputSetting setObject:[NSNumber numberWithFloat:appHeight] forKey:(id)kCVPixelBufferHeightKey];
    [imageOutputSetting setObject:AVVideoCodecJPEG forKey:(id)kCVPixelBufferWidthKey];
    imageOut.outputSettings = imageOutputSetting;
    if( [self.session canAddOutput:imageOut] )
    {
        [self.session addOutput:imageOut];
    }
    
    // add previewlayer to this view
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    layer.frame = self.frame;
    self.cameraLayer = layer;
    self.cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if( isFrontCamera )
    {
        [frontView.layer insertSublayer:cameraLayer below:captureButton.layer];
    }
    else
    {
        [backView.layer insertSublayer:cameraLayer below:captureButton.layer];
    }
    [layer release];
}

- (void)startCapture
{
    [self.session startRunning];
}

- (void)stopCapture
{
    [self.session stopRunning];
}

#pragma mark-
#pragma AVCaptureAudioDataOutputSampleBufferDelegate implement
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //捕捉数据输出
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the buffer*/
    if(CVPixelBufferLockBaseAddress(pixelBuffer, 0) == kCVReturnSuccess)
    {
        //    UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddress(pixelBuffer);
        //    size_t buffeSize = CVPixelBufferGetDataSize(pixelBuffer);
        
        /*
        if(_bFirstFrame)
        {
            if(1)
            {
                int pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
                switch (pixelFormat) {
                    case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
                        
                        NSLog(@"Capture pixel format=NV12");
                        break;
                    case kCVPixelFormatType_422YpCbCr8:
                        //TMEDIA_PRODUCER(producer)->video.chroma = tmedia_uyvy422; // iPhone 3
                        NSLog(@"Capture pixel format=UYUY422");
                        break;
                    default:
                        //TMEDIA_PRODUCER(producer)->video.chroma = tmedia_rgb32;
                        NSLog(@"Capture pixel format=RGB32");
                        break;
                }
                
                _bFirstFrame = NO;
            }
        }
        */
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    }
}

- (void)onTouchCapture:(id)sender
{
    NSLog(@"%s",__func__);
    AVCaptureConnection *conn = [self.imageOut connectionWithMediaType:AVMediaTypeVideo];
    if( conn )
    {
        [self.imageOut captureStillImageAsynchronouslyFromConnection:conn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){            
            if( imageDataSampleBuffer != NULL )
            {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                if( imageData )
                {
                    NSError *error = nil;
                    NSFileManager *fm = [NSFileManager defaultManager];
                    NSDate *date = [NSDate date];
                    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                    fmt.dateFormat = @"yyyy.MM";
                    NSString *yearMonth = [fmt stringFromDate:date];
                    fmt.dateFormat = @"d";
                    NSString *day = [fmt stringFromDate:date];
                    NSString *dir = [NSString stringWithFormat:@"%@/photos/%@/%@", self.documentPath, yearMonth, day];
                    if( ![fm fileExistsAtPath:dir] )
                    {
                        if( ![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error] )
                        {
                            if( error )
                            {
                                NSLog(@"%s, create path failed:%@", __func__, error);
                                error = nil;
                            }
                        }
                    }
                    fmt.dateFormat = @"yyyyMMddHHmmSS";
                    NSString *name = [fmt stringFromDate:date];
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", dir, name, FILE_TYPE];
                    NSLog(@"%s,path:%@", __func__, filePath);
                    if( ![fm fileExistsAtPath:self.documentPath] )
                    {
                        [fm createDirectoryAtPath:self.documentPath withIntermediateDirectories:NO attributes:nil error:&error];
                        if( error )
                        {
                            NSLog(@"%s, create path failed:%@", __func__, error);
                        }
                    }
                    BOOL bResult = [imageData writeToFile:filePath atomically:YES];
                    if( !bResult )
                    {
                        NSLog(@"%s, save picture:%@ failed", __func__, filePath);
                    }
                    
                    [[dataManager defaultMgr] insertPhotoInfoInBlock:^(PhotoInfo *info){
                        CLLocation *location = [locationMgr defaultMgr].location;
                        CLPlacemark *place = [locationMgr defaultMgr].place;
                        info.path = filePath;
                        info.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                        info.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                        info.altitude = [NSNumber numberWithDouble:location.altitude];
                        info.createTime = [NSDate date];
                        NSString *addr = [NSString stringWithFormat:@"%@ %@",place.thoroughfare, place.subThoroughfare];
                        if( addr.length == 0 )
                        {
                            addr = [NSString stringWithFormat:@"%@ %@", place.locality, place.subLocality];
                        }
                        if( addr.length == 0 )
                        {
                            addr = place.administrativeArea;
                        }
                        info.place = addr;
                    }];
                    [fmt release];
                }
            }
        }];
    }
}

- (void)onTouchToggleCamera:(id)sender
{
    [self setCameraType:YES];
    NSLog(@"%s",__func__);
}

- (void)onTouchToggleClose:(id)sender
{
    NSLog(@"%s",__func__);
    [self removeFromSuperview];
}

/*
- (void)check
{
    NSString *mediaType = AVMediaTypeVideo; // Or AVMediaTypeAudio
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    //
    if(authStatus == AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
                [self setCameraType:YES];
                if( self.camera )
                {
                    session = [[AVCaptureSession alloc] init];
                    [self initCamera];
                    [self startCapture];
                    
                }
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    }
    
    // The user has explicitly denied permission for media capture.
    else if(authStatus == AVAuthorizationStatusDenied){
        NSLog(@"Denied");
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
                [self setCameraType:YES];
                if( self.camera )
                {
                    session = [[AVCaptureSession alloc] init];
                    [self initCamera];
                    [self startCapture];
                    
                }
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    }
    
    //
    else if(authStatus == AVAuthorizationStatusAuthorized){
        NSLog(@"Authorized");
    }
    
    // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
    else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"Granted access to %@", mediaType);
                [self setCameraType:YES];
                if( self.camera )
                {
                    session = [[AVCaptureSession alloc] init];
                    [self initCamera];
                    [self startCapture];
                    
                }
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
        
    }
    
    else {
        NSLog(@"Unknown authorization status");
    }
    
}
*/

- (void)onSlideToRight:(UISwipeGestureRecognizer*)sgr
{
    [[ViewController defaultVC] dismissCameraView];
}

- (void)onSlideDown:(UISwipeGestureRecognizer*)sdgr
{
    [self stopCapture];
    isFrontCamera = !isFrontCamera;
    self.camera = nil;
    self.session = nil;
    [self setCameraType:isFrontCamera];
    if( self.camera )
    {
        /*
        if( isFrontCamera )
        {
            [frontView removeFromSuperview];
            self.frontView = nil;
            UIView *v = [[UIView alloc] initWithFrame:self.frame];
            self.frontView = v;
            [v release];
            [self addSubview:frontView];
        }
        else
        {
            [backView removeFromSuperview];
            self.backView = nil;
            UIView *v = [[UIView alloc] initWithFrame:self.frame];
            self.backView = v;
            [v release];
            [self addSubview:backView];
        }
        */
        session = [[AVCaptureSession alloc] init];
        [self initCamera];
        [self startCapture];
        NSInteger frontIndex = [self.subviews indexOfObject:frontView];
        NSInteger backIndex = [self.subviews indexOfObject:backView];
        if( isFrontCamera )
        {
            [self exchangeSubviewAtIndex:backIndex withSubviewAtIndex:frontIndex];
        }
        else
        {
            [self exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
        }
        CATransition *transition = [[CATransition alloc] init];
        transition.duration = 0.7f;
        transition.timingFunction = UIViewAnimationCurveEaseInOut;
        transition.type = @"cube";
        [self.layer addAnimation:transition forKey:@"animation"];
        [transition release];
    }

    [self bringSubviewToFront:captureButton];
}

- (void)onUpdateLocation:(CLLocation*)location placemark:(CLPlacemark*)mark
{
    CGRect labelFrame = CGRectMake(5, 30, 310, 18);
    
    if( latitude )
    {
        [latitude removeFromSuperview];
        [latitude release];
    }
    latitude = [[titleValueView alloc] initWithFrame:labelFrame title:@"纬度" Value:[NSString stringWithFormat:@"%f", location.coordinate.latitude]];
    [self addSubview:latitude];
    labelFrame.origin.y += latitude.height;
    
    if( longitude )
    {
        [longitude removeFromSuperview];
        [longitude release];
    }
    longitude = [[titleValueView alloc] initWithFrame:labelFrame title:@"经度" Value:[NSString stringWithFormat:@"%f", location.coordinate.longitude]];
    [self addSubview:longitude];
    labelFrame.origin.y += longitude.height;
    
    if( altitude )
    {
        [altitude removeFromSuperview];
        [altitude release];
    }
    altitude = [[titleValueView alloc] initWithFrame:labelFrame title:@"海拔" Value:[NSString stringWithFormat:@"%f", location.altitude]];
    [self addSubview:altitude];
    labelFrame.origin.y += altitude.height;
    
    if( contry )
    {
        [contry removeFromSuperview];
        contry = nil;
    }
    contry = [[titleValueView alloc] initWithFrame:labelFrame title:@"国家" Value:mark.country];
    [self addSubview:contry];
    labelFrame.origin.y += contry.height;
    
    if( administrativeArea )
    {
        [administrativeArea removeFromSuperview];
        administrativeArea = nil;
    }
    administrativeArea = [[titleValueView alloc] initWithFrame:labelFrame title:@"省份" Value:mark.administrativeArea];
    [self addSubview:administrativeArea];
    labelFrame.origin.y += administrativeArea.height;
    
    if( locality )
    {
        [locality removeFromSuperview];
        locality = nil;
    }
    locality = [[titleValueView alloc] initWithFrame:labelFrame title:@"市" Value:mark.locality];
    [self addSubview:locality];
    labelFrame.origin.y += locality.height;
    
    if( subLocality )
    {
        [subLocality removeFromSuperview];
        subLocality = nil;
    }
    subLocality = [[titleValueView alloc] initWithFrame:labelFrame title:@"县" Value:mark.subLocality];
    [self addSubview:subLocality];
    labelFrame.origin.y += subLocality.height;
    
    if( thoroughfare )
    {
        [thoroughfare removeFromSuperview];
        thoroughfare = nil;
    }
    thoroughfare = [[titleValueView alloc] initWithFrame:labelFrame title:@"街道" Value:mark.thoroughfare];
    [self addSubview:thoroughfare];
    labelFrame.origin.y += thoroughfare.height;
    
    if( subThoroughfare )
    {
        [subThoroughfare removeFromSuperview];
        subThoroughfare = nil;
    }
    subThoroughfare = [[titleValueView alloc] initWithFrame:labelFrame title:@"地址" Value:mark.subThoroughfare];
    [self addSubview:subThoroughfare];
    labelFrame.origin.y += subThoroughfare.height;
}

@end
