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
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imageView];
        tiledLayer = [[CATiledLayer alloc] init];
        tiledLayer.delegate = nil;
        tiledLayer.contentsGravity = kCAGravityResizeAspect;
        tiledLayer.geometryFlipped = YES;
        image = [[UIImage alloc] initWithContentsOfFile:photoPath];
        [imageView.layer addSublayer:tiledLayer];
        NSInteger width = image.size.width;
        NSInteger height = image.size.height;
        tiledLayer.levelsOfDetailBias = 5;
        tiledLayer.levelsOfDetail = 0;
        tiledLayer.bounds = self.layer.bounds;
        tiledLayer.position = self.layer.position;
        tiledLayer.anchorPoint = CGPointMake(0.5, 0.5);
        tiledLayer.backgroundColor = [UIColor whiteColor].CGColor;
        while( width > 0 && height >0 ){
            width = width >> 1;
            height = height >> 1;
            tiledLayer.levelsOfDetail++;
        }
        
        tiledLayerDelegagte *delegate = [[tiledLayerDelegagte alloc] init];
        delegate.image = image;
        delegate.bounds = self.bounds;
        tiledLayer.delegate = delegate;
    }
    return self;
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

@end
