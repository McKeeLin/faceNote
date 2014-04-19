//
//  photoDisplayView.m
//  faceNote
//
//  Created by cdc on 13-11-28.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "photoDisplayView.h"
#import "ViewController.h"
#import "dismissableTips.h"


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
        
        UISwipeGestureRecognizer *upSgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp:)];
        upSgr.numberOfTouchesRequired = 1;
        upSgr.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:upSgr];
        
        UISwipeGestureRecognizer *downSgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeDown:)];
        downSgr.numberOfTouchesRequired = 1;
        downSgr.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:downSgr];
        
    }
    return self;
}


- (void)didMoveToSuperview
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"photoViewShown";
    BOOL shown = [defaults boolForKey:key];
    if( !shown )
    {
        [defaults setBool:YES forKey:key];
        NSString *tips = @"1.左右滑动可切换照片\n\n2.双击可回到照片列表视图";//@"1.swipe to left or right to change photo \n\n2.dubble tap to switch to the album list view.";
        [dismissableTips showTips:tips blues:[NSArray arrayWithObject:tips] atView:self seconds:10 block:nil];
    }
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

- (void)onSwipeDown:(UISwipeGestureRecognizer*)sgr
{
}

- (void)onSwipeUp:(UISwipeGestureRecognizer*)sgr
{
    if( self.pageViews.count == 0 ){
        [[ViewController defaultVC] showListFromPhotoView];
        return;
    }
    
    UIView *currentPage = [self.pageViews objectAtIndex:self.currentIndex];
    CGRect originalFrame = currentPage.frame;
    if( currentPage ){
        [UIView animateWithDuration:1.0 animations:^(){
            currentPage.frame = CGRectOffset(originalFrame, 0, -self.frame.size.height);
        }completion:^(BOOL bfinished){
            if( self.pageViews.count > 1 )
            {
                if( self.currentIndex == self.pageViews.count - 1 )
                {
                    UIView *leftSideView = [self.pageViews objectAtIndex:self.currentIndex-1];
                    [UIView animateWithDuration:0.5 animations:^(){
                        leftSideView.frame = originalFrame;
                    } completion:^(BOOL bfinished){
                        [self.pageViews removeObject:currentPage];
                        self.currentIndex--;
                    }];
                }
                else{
                    UIView *rightSideView = [self.pageViews objectAtIndex:self.currentIndex+1];
                    [UIView animateWithDuration:0.5 animations:^(){
                        rightSideView.frame = originalFrame;
                    } completion:^(BOOL bfinished){
                        [self.pageViews removeObject:currentPage];
                    }];
                }
            }
            else if( self.pageViews.count == 1 ){
                [self.pageViews removeObject:currentPage];
            }
            
            /*
            if( self.currentIndex == self.pageViews.count - 1 ){
                // move left side page to current position
                if( self.currentIndex > 0 )
                {
                    UIView *leftSideView = [self.pageViews objectAtIndex:self.currentIndex-1];
                    [UIView animateWithDuration:0.5 animations:^(){
                        leftSideView.frame = self.bounds;
                    } completion:^(BOOL bfinished){
                        [self.pageViews removeObject:currentPage];
                        self.currentIndex--;
                    }];
                }
                else{
                    [self.pageViews removeObject:currentPage];
                }
            }
            else{
                // move right side page to current position
                if( self.pageViews.count > 1 ){
                    UIView *rightSideView = [self.pageViews objectAtIndex:self.currentIndex+1];
                    [UIView animateWithDuration:0.5 animations:^(){
                        rightSideView.frame = self.bounds;
                    } completion:^(BOOL bfinished){
                        [self.pageViews removeObject:currentPage];
                    }];
                }
                else{
                    [self.pageViews removeObject:currentPage];
                }
            }
             */
        }];
    }
}

@end
