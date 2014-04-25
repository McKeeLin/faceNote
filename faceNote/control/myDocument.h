//
//  myDocument.h
//  faceNote
//
//  Created by 林景隆 on 4/25/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myDocument : UIDocument


@property NSString *srcFile;

@property (retain) NSData *data;

- (void)initData;

@end
