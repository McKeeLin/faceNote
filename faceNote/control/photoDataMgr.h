//
//  photoMetaDataMgr.h
//  faceNote
//
//  Created by 林景隆 on 5/12/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "photoMetaDataObj.h"

@interface photoDataMgr : NSObject

@property (retain) NSMutableArray *photoGroups;

+ (photoDataMgr*)manager;

- (photoMetaDataObj*)metaDataOfPhoto:(NSString *)path;

- (UIImage*)thumbnailImageOfFile:(NSString*)file maxPixel:(float)max;

- (void)deletePhoto:(NSString*)path;

- (void)addPhoto:(NSData*)data;

- (void)encodeFile:(NSString*)file to:(NSString*)destFile;

- (void)decodeFile:(NSString*)file to:(NSString*)destFile;

- (void)synchronizePhotoFromICloudContainer;

- (void)loadData;

@end
