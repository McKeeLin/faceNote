//
//  photoDisplayView.m
//  faceNote
//
//  Created by cdc on 13-11-28.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "photoDisplayView.h"
#import "ViewController.h"


@implementation photoDisplayView
@synthesize point,vc;

- (void)dealloc
{
    [vc release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame subViews:(NSArray *)views defaultIndex:(NSInteger)index delegate:(id)dele
{
    self = [super initWithFrame:frame subViews:views defaultIndex:index delegate:dele];
    if( self )
    {
        UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTag:)];
        tg.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tg];
        [tg release];
    }
    return self;
}

- (void)onDoubleTag:(UITapGestureRecognizer*)tg
{
 //   [self removeFromSuperview];
    /*
    [UIView beginAnimations:@"suck" context:nil];
    [UIView setAnimationTransition:103 forView:self cache:YES];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationPosition:CGPointMake(0, 0)];
    [UIView commitAnimations];
    */
    
    [[ViewController defaultVC] showListFromPhotoView];
}

@end
