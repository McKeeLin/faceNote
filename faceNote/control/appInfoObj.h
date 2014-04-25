//
//  appInfoObj.h
//  faceNote
//
//  Created by 林景隆 on 4/23/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface appInfoObj : NSObject

+ (appInfoObj*)shareInstance;

- (NSURL*)iCloudContainerUrl;

- (NSURL*)newImageFileUrl;

@end
