//
//  PhotoInfo.h
//  faceNote
//
//  Created by cdc on 13-12-7.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PhotoInfo : NSManagedObject

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * weatherDegree;
@property (nonatomic, retain) NSString * weatherType;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end
