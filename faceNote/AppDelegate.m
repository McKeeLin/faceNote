//
//  AppDelegate.m
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "appInfoObj.h"
#import "icloudHelper.h"
#import "iAPHelper.h"
#import "gestureCodeVerifyView.h"
#import "photoDataMgr.h"
#import "photoScaleView.h"

@interface AppDelegate()<gestureCodeVerifyViewDelegate>
{
    icloudHelper *ihelper;
    gestureCodeVerifyView *verifyView;
}
@end

@implementation AppDelegate


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *info = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if( info ){
        [self parseRemoteNotification:info];
        NSLog(@"%s, info:%@", __func__, info);
    }
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [ViewController defaultVC];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    [self performSelectorInBackground:@selector(initiCloud) withObject:nil];
    [self checkVerifyCodeProtection];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[icloudHelper helper] isEnable];
    [self checkVerifyCodeProtection];
}

- (void)checkVerifyCodeProtection
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:kGestureCodeEnable];
    if( number && number.boolValue &&!verifyView ){
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:kGestureCode];
        verifyView = [[gestureCodeVerifyView alloc] initWithFrame:window.bounds code:code limit:3 delegate:self back:NO];
        [window addSubview:verifyView];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [ViewController defaultVC];
}

- (void)parseRemoteNotification:(NSDictionary *)info
{
    NSLog(@"%s, notification:%@", __func__, info);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%s, token:%@", __func__, deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s, error:%@", __func__, error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%s, info:%@", __func__, userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%s, info:%@", __func__, userInfo);
}

- (void)initiCloud
{
    [[appInfoObj shareInstance] iCloudContainerUrl];
}

- (void)didGestureCodeIsValid:(NSString*)code
{
    [verifyView removeFromSuperview];
    verifyView = nil;
}

- (void)didInvalidGestureCodeReachLimitTimes:(int)times
{
    ;
}

@end
