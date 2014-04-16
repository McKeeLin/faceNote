//
//  settingView.m
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//
#import "UIImage+BoxBlur.h"
#import "settingView.h"
#import "maskGlassView.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface settingView()
{
    UIImageView *imv;
}

@end

@implementation settingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
        iv.image = [UIImage imageNamed:@"wait"];
        [self addSubview:iv];
        [iv release];
        
        CGRect mvFrame = self.bounds;
        maskGlassView *mv = [[maskGlassView alloc] initWithFrame:mvFrame];
        [self addSubview:mv];        
        [mv release];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(50, 50, 50, 50);
        btn.backgroundColor = [UIColor greenColor];
        [btn addTarget:self action:@selector(onTouchBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
    
    return self;
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

- (UIImage*)blurImage:(UIImage*)img withRadius:(CGFloat)radius
{
    UIImage *newImg = nil;
    if( radius <.0f || radius > 1.0f )
    {
        radius = 0.5f;
    }
    
    CGSize imgSize = img.size;
    NSInteger boxWidth = imgSize.width / 10;
    NSInteger boxHeight = imgSize.height / 10;
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



- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (void)onTouchBtn:(id)sender
{
}
@end
