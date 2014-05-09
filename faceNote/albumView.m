//
//  albumView.m
//  faceNote
//
//  Created by cdc on 13-11-23.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "albumView.h"
#import "UIApplication+appSize.h"
#import "photoDisplayView.h"
#import "photoView.h"
#import "ViewController.h"
#import "thumbImageHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface albumView()
{
    NSMutableArray *subBounds;
}


@end

@implementation albumView
@synthesize albumHeight,photoPaths;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame album:(album *)am
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.photoPaths = [[NSMutableArray alloc] initWithCapacity:0];
        [self.photoPaths addObjectsFromArray:am.photos];
        subBounds = [[NSMutableArray alloc] initWithCapacity:0];
        albumHeight = 150;
        NSInteger radom = am.title.integerValue;
        [self initSubBoundsWith:radom count:am.photos.count];
    }
    return self;
}

- (void)relayout
{
    NSArray *subViews = [NSArray arrayWithArray:self.subviews];
    for( UIView *subView in subViews ){
        [subView removeFromSuperview];
    }
    [subBounds removeAllObjects];
    
    for( NSString *path in photoPaths ){
        [[thumbImageHelper helper].thumbImages removeObjectForKey:path];
    }
    
    NSInteger radom = 517;
    [self initSubBoundsWith:radom count:self.photoPaths.count];
}

- (void)dealloc
{
    [subBounds release];
    [photoPaths release];
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

- (BOOL)shouldHorDevide:(NSInteger*)radom
{
    NSInteger m = *radom / 2;
    NSInteger n = *radom % 2;
    *radom = m;
    if( n == 1 )
    {
        return YES;
    }
    return NO;
}

- (void)initSubBoundsWith:(NSInteger)radom count:(NSInteger)count
{
    NSLog(@"%s, count:%d", __func__, count);
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger r = radom;
    NSInteger d = count;
    if( d > 10 )
    {
        d = 10;
    }
    BOOL horDevide = [self shouldHorDevide:&r];
    horDevide = YES;
    NSInteger minWidth = size.width / d;
    NSInteger minHeight = minWidth;
    
    CGFloat availableWidth = self.bounds.size.width;
    CGFloat availableHeight = self.bounds.size.height;
    CGFloat newWidth;
    CGFloat newHeight;
    NSInteger moder = 4;
    NSInteger start = 3;
    CGFloat left = 0;
    CGFloat availableLeft = 0;
    CGFloat top = 0;
    CGFloat availableTop = 0;
    CGFloat width = availableWidth;
    CGFloat height = availableHeight;
    NSInteger i = 0;
    while( subBounds.count < count )
    {
        if( i == count - 1 )
        {
            left = availableLeft;
            top = availableTop;
            width = availableWidth;
            height = availableHeight;
            [self addButtonWithLeft:left Top:top Width:width Height:height index:i];
            break;
        }
        
        if( horDevide )
        {
            if( availableWidth >= 2 * minWidth )
            {
                NSInteger n = start + r % moder;
                newWidth = availableWidth * n / 10;
                if( newHeight >= availableWidth / 2 )
                {
                    left = availableLeft + newWidth + 1;
                    width = availableWidth - newWidth - 1;
                    availableWidth = newWidth;
                }
                else
                {
                    left = availableLeft;
                    width = newWidth;
                    availableLeft = left + newWidth + 1;
                    availableWidth = availableWidth - newWidth - 1;
                }
                    
                horDevide = [self shouldHorDevide:&r];
                top = availableTop;
                height = availableHeight;
                [self addButtonWithLeft:left Top:top Width:width Height:height index:i];
                i++;
            }
            else
            {
                horDevide = NO;
            }
        }
        else
        {
            if( availableHeight >= 2 * minHeight )
            {
                NSInteger n = 1 + radom % 3;
                newHeight = availableHeight * n / 3;
                if( newHeight > availableHeight / 2 )
                {
                    height = availableHeight - newHeight - 1;
                    top = availableTop + newHeight + 1;
                    availableHeight = newHeight;
                }
                else
                {
                    top = availableTop;
                    height = newHeight;
                    availableTop = top + height + 1;
                    availableHeight -= newHeight + 1;
                }
                horDevide = [self shouldHorDevide:&r];
                left = availableLeft;
                width = availableWidth;
                [self addButtonWithLeft:left Top:top Width:width Height:height index:i];
                i++;
           }
            else
            {
                horDevide = YES;
            }
        }
        
        if( availableWidth < 2 * minWidth && availableHeight < 2 * minHeight )
        {
            if( i < photoPaths.count )
            {
                [self addButtonWithLeft:availableLeft Top:availableTop Width:availableWidth Height:availableHeight index:i];
            }
            break;
        }
    }
}

- (void)addButtonWithLeft:(CGFloat)left Top:(CGFloat)top Width:(CGFloat)width Height:(CGFloat)height index:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(left, top, width, height);
        btn.backgroundColor = [UIColor grayColor];
        btn.tag = index;
        [btn addTarget:self action:@selector(onTouchPhoto:) forControlEvents:UIControlEventTouchUpInside];
        NSString *path = [photoPaths objectAtIndex:index];
        UIImage *btnImg = [[thumbImageHelper helper].thumbImages objectForKey:path];
        if( btnImg )
        {
            CGSize btnImgSize = btnImg.size;
            if( btnImgSize.width != width || btnImgSize.height != height ){
                btnImg = nil;
                [[thumbImageHelper helper].thumbImages removeObjectForKey:path];
            }
        }
        if( !btnImg ){
            NSLog(@".................1");
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:[photoPaths objectAtIndex:index]];
            CGSize size = img.size;
            CGFloat newWidth = width;
            CGFloat newHeight = height;
            
            CGFloat horScale = size.width / width;
            CGFloat verScale = size.height / height;
            if( verScale < horScale )
            {
                newHeight = size.height / verScale;
                newWidth = size.width / verScale;
            }
            else
            {
                newWidth = size.width / horScale;
                newHeight = size.height / horScale;
            }
            ///*
            //    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), YES, 0.0);
            NSLog(@"................11");
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            CGContextRef context = UIGraphicsGetCurrentContext();
            if( !context )
            {
                UIGraphicsEndImageContext();
                [img release];
                return;
            }
            
            NSLog(@".................2");
            [img drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
            /*
             CALayer *layer = [[CALayer alloc] init];
             layer.bounds = CGRectMake(0, 0, newWidth, newHeight);
             layer.contentsGravity = kCAGravityResizeAspectFill;
             layer.contents = (id)img.CGImage;
             [layer renderInContext:context];
             */
            NSLog(@".................3");
            UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //    UIImage *scaleImg = [UIImage imageWithCGImage:img.CGImage scale:scale orientation:UIImageOrientationRight];
            CGFloat newTop = (newHeight - height)/2;
            if( newTop < 0 ) newTop *= -1;
            CGFloat newLeft = (newWidth - width)/2;
            if( newLeft < 0 ) newLeft *= -1;
            NSLog(@".................4");
            CGImageRef imgRef = CGImageCreateWithImageInRect(newImg.CGImage, CGRectMake(newLeft, newTop, width, height));
            NSLog(@".................5");
            btnImg = [[UIImage alloc] initWithCGImage:imgRef];
            [[thumbImageHelper helper].thumbImages setObject:btnImg forKey:path];
            CGImageRelease(imgRef);
            //*/
            NSLog(@".................6");
            [img release];
            [btn setImage:btnImg forState:UIControlStateNormal];
            NSLog(@".................7");
            [btnImg release];
        }
        else
        {
            [btn setImage:btnImg forState:UIControlStateNormal];
        }
        [self addSubview:btn];
        [subBounds addObject:btn];
    });
}

- (void)onTouchPhoto:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [[ViewController defaultVC] showPhotoFromListViewWithPaths:photoPaths defaultIndex:btn.tag albumView:self];
}

@end
