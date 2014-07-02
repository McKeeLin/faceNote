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

@property (retain) NSString *photoDir;

+ (photoDataMgr*)manager;

- (photoMetaDataObj*)metaDataOfPhoto:(NSString *)path;

- (UIImage*)thumbnailImageOfFile:(NSString*)file maxPixel:(float)max;

- (UIImage*)imageFromFile:(NSString*)file;

- (void)deletePhoto:(NSString*)path;

- (void)addPhoto:(NSData*)data photoType:(PHOTO_TYPE)type;

- (void)encodeFile:(NSString*)file to:(NSString*)destFile;

- (void)decodeFile:(NSString*)file to:(NSString*)destFile;

- (void)synchronizePhotoFromICloudContainer;

- (void)loadData;

@end
