//
//  photoInfoObj.h
//  faceNote
//
//  Created by 林景隆 on 5/12/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface photoMetaDataObj : NSObject

@property (retain)NSString *path;

@property (retain)NSString *location;

@property (retain)NSString *creteTime;

@property CGFloat width;

@property CGFloat height;

@property CLLocationDegrees latitude;

@property CLLocationDegrees longitude;

@property CLLocationDegrees altitude;

@end
