//
//  UIImage+UIImageScale.h
//  faceNote
//
//  Created by cdc on 13-11-26.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)
-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage*)getSubImage:(CGRect)rect;
@end
