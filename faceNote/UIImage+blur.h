//
//  UIImage+blur.h
//  faceNote
//
//  Created by cdc on 13-12-4.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (blur)

+ (UIImage*)blurImage:(UIImage*)img withRadius:(CGFloat)radius;

+ (UIImage*)imageFromView:(UIView*)view width:(CGFloat)width height:(CGFloat)height;

+ (UIImage*)scaleFrom:(UIImage*)source width:(CGFloat)width height:(CGFloat)height;

@end
