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
@property BOOL synchronizationEnabled;

+ (icloudHelper*)helper;

- (void)queryGroups;

- (BOOL)isEnable;

- (NSURL*)newImageUrl;

- (void)movePhotoToICloud:(NSString*)photoPath;

@end
