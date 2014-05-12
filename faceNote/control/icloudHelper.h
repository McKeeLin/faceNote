//
//  icloudHelper.h
//  faceNote
//
//  Created by 林景隆 on 4/23/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface icloudHelper : NSObject
@property (retain) NSURL *containerUrl;
@property (retain) NSString *appDocumentPath;
@property (retain) NSString *iCloudDocumentPath;

+ (icloudHelper*)helper;

- (void)queryGroups;

- (BOOL)isEnable;

- (NSURL*)newImageUrl;

- (void)movePhotoToICloud:(NSString*)photoPath;

- (void)encodeFile:(NSString*)file to:(NSString*)destFile;

- (void)decodeFile:(NSString*)file to:(NSString*)destFile;

@end
