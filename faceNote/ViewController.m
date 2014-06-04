//
//  ViewController.m
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "ViewController.h"
#import "captureView.h"
#import "pageMgrView.h"
#import "listView.h"
#import "captureView.h"
#import "settingView.h"
#import "def.h"
#import "locationMgr.h"
#import "photoDisplayView.h"
#import "photoView.h"
#import "album.h"
#import <QuartzCore/QuartzCore.h>
#import "dataManager.h"
#import "albumListView.h"
#import "photoDataMgr.h"
#import "photoScaleView.h"
#import <QuartzCore/QuartzCore.h>

CGFloat appWidth;

CGFloat appHeight;

ViewController *g_vc;


@interface ViewController ()
{
    CGRect bounds;
}

@property (retain) pageMgrView *pageMgr;

@property (retain) albumListView *ltv;

@property (retain) captureView *cameraView;

@property (retain) photoDisplayView *pdv;

@end

@implementation ViewController
@synthesize pageMgr,ltv,cameraView,pdv;

+ (ViewController*)defaultVC
{
    if( !g_vc )
    {
        g_vc = [[ViewController alloc] init];
    }
    return g_vc;
}

+ (void)destroy
{
    [g_vc release];
    g_vc = nil;
}

- (void)dealloc
{
    [pageMgr release];
    [locationMgr destroy];
    [ltv release];
    [cameraView release];
    [pdv release];
    [dataManager destroy];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%f,%f", self.view.bounds.size.width,self.view.bounds.size.height );
    bounds = self.view.frame;
    CGSize size = [self appSize];
    bounds.size = size;
    captureView *cpv = [[captureView alloc] initWithFrame:bounds];
    cpv.vc = self;
    self.cameraView = cpv;
    [cpv release];
//    settingView *stv = [[settingView alloc] initWithFrame:bounds];
    /*
    ltv = [[listView alloc] initWithFrame:bounds];
    pageMgr = [[pageMgrView alloc] initWithFrame:bounds subViews:[NSArray arrayWithObjects:ltv,cpv,stv, nil] defaultIndex:0 delegate:self];
    [self.view addSubview:pageMgr];
    [cpv release];
    [stv release];
    */
    [self.view addSubview:cameraView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s,%f,%f", __func__, self.view.bounds.size.width,self.view.bounds.size.height );
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __func__);
    [self performSelector:@selector(doLocation) withObject:nil afterDelay:1.0];
}

- (void)doLocation
{
    [[locationMgr defaultMgr] doLocation];
}

- (CGSize)appSize
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect bs = [[UIScreen mainScreen] bounds];
    NSLog(@"%s, appframe:%f,%f,%f,%f, bounds:%f,%f,%f,%f", __func__, appFrame.origin.x,appFrame.origin.y,appFrame.size.width,appFrame.size.height, bs.origin.x,bs.origin.y,bs.size.width,bs.size.height);
    CGFloat width;
    CGFloat height;
    if( bs.size.width == appFrame.size.width )
    {
        width = appFrame.size.width;
        height = appFrame.size.height;
    }
    else
    {
        width = appFrame.size.height;
        height = appFrame.size.width;
    }
    
    if( [[UIDevice currentDevice] systemVersion].floatValue >= 7.0 ){
        height += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    appWidth = width;
    appHeight = height;
    return CGSizeMake(width, height);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect bs = [[UIScreen mainScreen] bounds];
    NSLog(@"%s, appframe:%f,%f,%f,%f, bounds:%f,%f,%f,%f", __func__, appFrame.origin.x,appFrame.origin.y,appFrame.size.width,appFrame.size.height, bs.origin.x,bs.origin.y,bs.size.width,bs.size.height);
}

- (void)didShowPage:(id)page atIndex:(NSInteger)index
{
    if( index == 0 )
    {
//        [ltv loadImages];
    }
}

- (void)showListFromCameraView
{
    if( !ltv )
    {
        CGRect frame = CGRectMake(0, 0, appWidth, appHeight);
        /*
        listView *lv = [[listView alloc] initWithFrame:frame];
        lv.vc = self;
        self.ltv = lv;
        [lv release];
        [self.view addSubview:ltv];
        */
        albumListView *v = [[albumListView alloc] initWithFrame:frame];
        v.vc = self;
        self.ltv = v;
        [self.view addSubview:v];
        [v release];
    }
    else
    {
        [ltv loadImages];
    }
    
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        NSInteger ltvIndex = [self.view.subviews indexOfObject:ltv];
        NSInteger cameraIndex = [self.view.subviews indexOfObject:cameraView];
        [self.view exchangeSubviewAtIndex:cameraIndex withSubviewAtIndex:ltvIndex];
        self.cameraView = nil;
        [UIView commitAnimations];
    }
    
}

- (void)showCameraFromListView
{
    if( !cameraView )
    {
        captureView *cpv = [[captureView alloc] initWithFrame:bounds];
        cpv.vc = self;
        self.cameraView = cpv;
        [cpv release];
    }
    [self.view addSubview:cameraView];
    self.ltv = nil;
}

- (void)showPhotoFromListViewWithPaths:(NSArray *)photoPaths defaultIndex:(NSInteger)index albumView:(albumView*)av
{
    if( !pdv )
    {
        NSMutableArray *photoes = [[NSMutableArray alloc] init];
        CGRect photoFrame;
        photoFrame.origin.x = 0;
        photoFrame.origin.y = 0;
        photoFrame.size = CGSizeMake(appWidth, appHeight);
        for( NSString *photo in photoPaths )
        {
            photoView *pv = [[photoView alloc] initWithFrame:photoFrame path:photo];
            [photoes addObject:pv];
            [pv release];
        }
        photoDisplayView *pdView = [[photoDisplayView alloc] initWithFrame:bounds subViews:photoes defaultIndex:index delegate:nil];
        pdView.vc = self;
        pdView.av = av;
        self.pdv = pdView;
        [pdView release];
        [photoes release];
        
        CATransition *animation = [CATransition alloc];
        animation.type = @"rippleEffect";
        animation.duration = 0.1;
        animation.delegate = self;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        [self.view insertSubview:pdv belowSubview:ltv];
        [self.view addSubview:pdv];
        [self.view.layer addAnimation:animation forKey:@"animation"];
        [animation release];
        /*
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.view addSubview:pdv];
        [UIView commitAnimations];
        */
        
        
    }
    else
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        NSInteger ltvIndex = [self.view.subviews indexOfObject:ltv];
        NSInteger pdvIndex = [self.view.subviews indexOfObject:pdv];
        [self.view exchangeSubviewAtIndex:ltvIndex withSubviewAtIndex:pdvIndex];
        [UIView commitAnimations];
    }
}

- (void)showListFromPhotoView
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:103 forView:self.view cache:YES];
    NSInteger ltvIndex = [self.view.subviews indexOfObject:ltv];
    NSInteger pdvIndex = [self.view.subviews indexOfObject:pdv];
    [self.view exchangeSubviewAtIndex:pdvIndex withSubviewAtIndex:ltvIndex];
    [pdv removeFromSuperview];
    self.pdv = nil;
    [UIView commitAnimations];
}

- (void)dismissCameraView
{
    NSInteger cameraViewIndex = [self.view.subviews indexOfObject:cameraView];
    id obj = nil;
    if( cameraViewIndex > 0 )
    {
        NSInteger followedIndex = cameraViewIndex - 1;
        obj = [self.view.subviews objectAtIndex:followedIndex];
    }
    [cameraView removeFromSuperview];
    if( !obj )
    {
        if( !ltv )
        {
            /*
            listView *lv = [[listView alloc] initWithFrame:bounds];
            lv.vc = self;
             self.ltv = lv;
             [lv release];
             [self.view addSubview:ltv];
            */
            albumListView *lv = [[albumListView alloc] initWithFrame:bounds];
            lv.vc = self;
            self.ltv = lv;
            [self.view addSubview:lv];
            [lv release];
        }
        else
        {
            [ltv loadImages];
            [self.view bringSubviewToFront:ltv];
        }
    }
    
    /*
    if( [obj isKindOfClass:[listView class]] )
    {
        [obj loadImages];
    }
    */
    
    CATransition *animation = [[CATransition alloc] init];
    animation.duration = 0.5f;
    animation.type = @"kCATransitionFade";
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    [self.view.layer addAnimation:animation forKey:@"anmition"];
    [animation release];
    self.cameraView = nil;
}
@end
