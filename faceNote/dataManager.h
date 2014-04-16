//
//  dataManager.h
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhotoInfo;

@interface dataManager : NSObject

+ (dataManager*)defaultMgr;

+ (void)destroy;

- (PhotoInfo*)queryPhotoInfoByPath:(NSString*)path;

- (void)deletePhotoInfoByPath:(NSString*)path;

- (void)deletePhotoInfo:(PhotoInfo*)info;

- (void)updatePhotoInfo:(PhotoInfo*)info;

- (void)addPhotoInfo:(PhotoInfo*)info;

- (void)insertPhotoInfoInBlock:(void(^)(PhotoInfo* info))block;

@end
