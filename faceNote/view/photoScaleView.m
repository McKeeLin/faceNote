//
//  photoView.m
//  OA
//
//  Created by 林景隆 on 5/14/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "photoScaleView.h"
#import "tiledLayerDelegagte.h"
#import <QuartzCore/QuartzCore.h>
#import "photoDataMgr.h"
#import "photoMetaDataObj.h"

@interface photoScaleView()<UIScrollViewDelegate>
{
    CATiledLayer *tiledLayer;
    UIImage *image;
    UIImageView *imageView;
}
@end

@implementation photoScaleView
@synthesize photoPath;

- (id)initWithFrame:(CGRect)frame photoPath:(NSString*)path
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photoPath = path;
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 50.0;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if( newSuperview ){
        imageView.userInteractionEnabled = YES;
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [[photoDataMgr manager] imageFromFile:photoPath];
        [self addSubview:imageView];
    }
}

- (void)dealloc
{
    [photoPath release];
    [tiledLayer release];
    [image release];
    [imageView release];
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"%s", __func__);
    return imageView;
}

-(UIImage*)rotateImage:(UIImage*)img to:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    CGSize size = img.size;
    bnds.size = size;
    rect.size = size;
    
    switch (orient)
    {
        case UIImageOrientationUp:
            return img;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, -M_PI/2);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, -M_PI/2);
            break;
            
        case UIImageOrientationRight:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI/2);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds.size = swapWidthAndHeight(bnds.size);
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI/2);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, img.CGImage);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}

@end
