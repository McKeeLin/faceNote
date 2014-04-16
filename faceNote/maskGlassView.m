//
//  maskGlassView.m
//  faceNote
//
//  Created by cdc on 13-12-1.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "maskGlassView.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>



@implementation maskGlassView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)willMoveToSuperview:(UIView *)newSuperview
{
}

- (void)didMoveToSuperview
{
    UIView *newSuperview = self.superview;
    CGRect orginalFrame = self.frame;
    CGRect visibleRect = [newSuperview convertRect:self.frame toView:self];
    visibleRect.origin.x += self.frame.origin.x;
    visibleRect.origin.y += self.frame.origin.y;
    visibleRect = orginalFrame;
    
    UIGraphicsBeginImageContextWithOptions(visibleRect.size, YES, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -visibleRect.origin.x, -visibleRect.origin.y);
    CALayer *superViewLayer = newSuperview.layer;
    [superViewLayer renderInContext:context];
    __block UIImage *superImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if( !superImage )
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSData *data = UIImageJPEGRepresentation(superImage, 0.01);
        UIImage *img = [UIImage imageWithData:data];
        UIImage *glassImg = [self blurImage:img withRadius:0.5];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.layer.contents = (id)glassImg.CGImage;
        });
    });
}

- (UIImage*)blurImage:(UIImage*)img withRadius:(CGFloat)radius
{
    UIImage *newImg = nil;
    if( radius <.0f || radius > 1.0f )
    {
        radius = 0.5f;
    }
    
    CGSize imgSize = img.size;
    NSInteger wh = 100 * radius;
    wh -= wh % 2 + 1;
    NSInteger boxWidth = wh;
    NSInteger boxHeight = wh;
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

@end
