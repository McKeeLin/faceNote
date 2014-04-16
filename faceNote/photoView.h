//
//  photoView.h
//  faceNote
//
//  Created by cdc on 13-11-28.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoInfo;

@interface photoView : UIView

@property (retain) NSString *photoPath;

@property (retain) PhotoInfo *info;

- (id)initWithFrame:(CGRect)frame path:(NSString*)path;



@end
