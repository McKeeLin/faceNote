//
//  locationMgr.h
//  faceNote
//
//  Created by cdc on 13-11-16.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLPlacemark.h>

@protocol locationMgrDelegate <NSObject>

- (void)onUpdateLocation:(CLLocation*)location placemark:(CLPlacemark*)mark;

@end

@interface locationMgr : NSObject

@property (retain) CLPlacemark *place;

@property (retain) CLLocation *location;

+ (locationMgr*)defaultMgr;

+ (void)destroy;

- (void)doLocation;

- (void)addDelegate:(id)dele;

@end
