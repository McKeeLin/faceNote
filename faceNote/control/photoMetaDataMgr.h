//
//  photoMetaDataMgr.h
//  faceNote
//
//  Created by 林景隆 on 5/12/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "photoMetaDataObj.h"

@interface photoMetaDataMgr : NSObject

+ (void)updatePropertiesOfPhoto:(photoMetaDataObj*)metaData;

@end
