//
//  UIImage+blur.m
//  faceNote
//
//  Created by cdc on 13-12-4.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "UIImage+blur.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>


@implementation UIImage (blur)

+ (UIImage*)imageFromView:(UIView *)view width:(CGFloat)width height:(CGFloat)height
{
    CGRect visibleRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContextWithOptions(visibleRect.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -visibleRect.origin.x, -visibleRect.origin.y);
    CALayer *layer = view.layer;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    [layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(img, 0.01);
    return [UIImage imageWithData:data];
}

+ (UIImage*)blurImage:(UIImage*)img withRadius:(CGFloat)radius
{
    UIImage *newImg = nil;
    /*
    if( radius <.0f || radius > 1.0f )
    {
        radius = 0.5f;
    }
    */
    
    CGSize imgSize = img.size;
    NSInteger wh = 100 * radius;
    wh -= wh % 2 + 1;
    NSInteger boxWidth = wh;
    NSInteger boxHeight = wh;
    boxWidth = imgSize.width * radius;
    boxHeight = imgSize.height * radius;
    if( boxWidth % 2 != 1 ) boxWidth++;
    if( boxHeight % 2 != 1 ) boxHeight++;
    CGImageRef imgRef = img.CGImage;
    vImage_Buffer inBuf;
    vImage_Buffer outBuf;
    vImage_Error err;
    size_t rowBytes = CGImageGetBytesPerRow(imgRef);
    void *pixelBuf = malloc( rowBytes * imgSize.height );
    CGDataProviderRef provider = CGImageGetDataProvider(imgRef);
    CFDataRef data = CGDataProviderCopyData(provider);
    
    inBuf.width = imgSize.width;
    inBuf.height = imgSize.height;
    inBuf.rowBytes = rowBytes;
    inBuf.data = (void*)CFDataGetBytePtr(data);
    outBuf.width = imgSize.width;
    outBuf.height = imgSize.height;
    outBuf.data = pixelBuf;
    outBuf.rowBytes = rowBytes;
    err = vImageBoxConvolve_ARGB8888(&inBuf, &outBuf, NULL, 0, 0, boxWidth, boxHeight, NULL, kvImageEdgeExtend);
    if( err == kvImageNoError )
    {
        CGColorSpaceRef color = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(outBuf.data, imgSize.width, imgSize.height, 8, rowBytes, color, CGImageGetBitmapInfo(imgRef));
        CGImageRef newImgRef = CGBitmapContextCreateImage(newContext);
        newImg = [UIImage imageWithCGImage:newImgRef];
        CGColorSpaceRelease(color);
        CGContextRelease(newContext);
        CGImageRelease(newImgRef);
    }
    
    
    free( pixelBuf );
    CFRelease(data);
    if( !newImg )
        newImg = img;
    return newImg;
}

+ (UIImage*)scaleFrom:(UIImage *)source width:(CGFloat)width height:(CGFloat)height
{
    CGFloat sourceWidth = CGImageGetWidth(source.CGImage);
    CGFloat sourceHeight = CGImageGetHeight(source.CGImage);
    
    float verticalRadio = sourceHeight*1.0/height;
    float horizontalRadio = sourceWidth*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
//    width = width*radio;
//    height = height*radio;
    
//    int xPos = (width - sourceWidth)/2;
//    int yPos = (height - sourceHeight)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
//    NSLog(@"1");
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0.0);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, width, height);
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.contents = (id)source.CGImage;
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    [layer release];
    return scaledImage;
}

@end
