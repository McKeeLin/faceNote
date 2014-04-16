//
//  locationMgr.m
//  faceNote
//
//  Created by cdc on 13-11-16.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "locationMgr.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLGeocoder.h>

locationMgr *g_locationMgr;

@interface locationMgr()<CLLocationManagerDelegate>
{
    CLLocationManager *mgr;
    NSMutableArray *delegates;
}

@end

@implementation locationMgr
@synthesize place,location;

+ (locationMgr*)defaultMgr
{
    if( !g_locationMgr )
    {
        g_locationMgr = [[locationMgr alloc] init];
    }
    return g_locationMgr;
}

+ (void)destroy
{
    [g_locationMgr release];
    g_locationMgr = nil;
}

- (id)init
{
    self = [super init];
    if( self )
    {
        mgr = [[CLLocationManager alloc] init];
        [mgr setDesiredAccuracy:kCLLocationAccuracyBest];
        [mgr setDistanceFilter:100.0f];
        mgr.delegate = self;
        delegates = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [mgr release];
    [place release];
    [location release];
    [delegates release];
    [super dealloc];
}

- (void)doLocation
{
    NSLog(@"%s", __func__);
   if( ![CLLocationManager locationServicesEnabled] )
   {
       ;
   }


    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
   if( kCLAuthorizationStatusAuthorized == status || kCLAuthorizationStatusNotDetermined == status )
   {
       [mgr startUpdatingLocation];
    //   [mgr release];
   }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"locations:%@",locations);
    self.location = [locations objectAtIndex:locations.count - 1];
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        self.place = [placemarks objectAtIndex:0];
        NSLog(@"country:%@", place.country);
        NSLog(@"administrativeArea:%@", place.administrativeArea);
        NSLog(@"subAdministrativeArea:%@", place.subAdministrativeArea);
        NSLog(@"locality:%@", place.locality);
        NSLog(@"subLocality:%@", place.subLocality);
        NSLog(@"thoroughfare:%@", place.thoroughfare);
        NSLog(@"subThoroughfare:%@", place.subThoroughfare);
        NSLog(@"postalCode:%@", place.postalCode);
        NSLog(@":%@", place);
        
        NSLog(@"placemarks:\n%@", placemarks);
        NSLog(@"-----");
    }];
    
    for( id<locationMgrDelegate> delegate in delegates )
    {
        if( [delegate respondsToSelector:@selector(onUpdateLocation:placemark:)] )
        {
            [delegate onUpdateLocation:location placemark:place];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, error:%@", __func__, error);
}

- (void)addDelegate:(id)dele
{
    for( id delegate in delegates )
    {
        if( dele == delegate )
        {
            return;
        }
    }
    [delegates addObject:dele];
}

@end
