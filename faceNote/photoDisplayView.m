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
#import "photoView.h"
#import "icloudHelper.h"
#import "iAPHelper.h"
#import "albumView.h"

@interface photoDisplayView()<UIGestureRecognizerDelegate>
{
    CGFloat yStart;
    CGFloat viewYStart;
    CGRect originalFrame;
}
@end

@implementation photoDisplayView
@synthesize point,vc,av;

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.pageViews removeAllObjects];
    [self.pageViews release];
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
//        [self addGestureRecognizer:upSgr];
        [upSgr release];
        
        UISwipeGestureRecognizer *downSgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeDown:)];
        downSgr.numberOfTouchesRequired = 1;
        downSgr.direction = UISwipeGestureRecognizerDirectionDown;
//        [self addGestureRecognizer:downSgr];
        [downSgr release];
        
        UIPanGestureRecognizer *dragUpGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDragUp:)];
        dragUpGesture.delegate = self;
        [dragUpGesture requireGestureRecognizerToFail:self.rsgr];
        [dragUpGesture requireGestureRecognizerToFail:self.lsgr];
        [self addGestureRecognizer:dragUpGesture];
        UIView *currentPage = [self.pageViews objectAtIndex:self.currentIndex];
        originalFrame = currentPage.frame;
        [dragUpGesture release];
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
        NSString *tips = @"1.左右滑动可切换照片\n\n2.双击可回到照片列表视图\n2.上滑可删除照片并从iCloud上删除";//@"1.swipe to left or right to change photo \n\n2.dubble tap to switch to the album list view.";
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
    if( av ){
        [av relayout];
    }
    [[ViewController defaultVC] showListFromPhotoView];
}

- (void)onSwipeDown:(UISwipeGestureRecognizer*)sgr
{
    photoView *pv = (photoView*)[self.pageViews objectAtIndex:self.currentIndex];
    [[icloudHelper helper] movePhotoToICloud:pv.photoPath];
}

- (void)onSwipeUp:(UISwipeGestureRecognizer*)sgr
{
    if( self.pageViews.count == 0 ){
        [[ViewController defaultVC] showListFromPhotoView];
        return;
    }
    
    UIView *currentPage = [self.pageViews objectAtIndex:self.currentIndex];
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
        }];
    }
}

- (void)onDragUp:(UIPanGestureRecognizer*)pgr
{
    NSLog(@"%s",__func__);
    if( self.pageViews.count == 0 ){
        [[ViewController defaultVC] showListFromPhotoView];
        return;
    }
    
    CGPoint currentPoint = [pgr translationInView:self];
    UIView *view = [self.pageViews objectAtIndex:self.currentIndex];
    __block CGRect viewFrame = view.frame;
    
    if( pgr.state == UIGestureRecognizerStateEnded )
    {
        NSLog(@"end");
        if( yStart - currentPoint.y > viewFrame.size.height / 2 )
        {
            photoView *currentPage = (photoView*)[self.pageViews objectAtIndex:self.currentIndex];
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
                    
                    // remove from iCloud
                    NSURL *url = [NSURL fileURLWithPath:currentPage.photoPath];
                    NSError *err = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:currentPage.photoPath error:&err];
                    if( err )
                    {
                        NSLog(@"%s, delete %@ failed, error:%@", __func__, currentPage.photoPath, err.localizedDescription);
                    }
                    
                    if( [iAPHelper helper].bPurchased ){
                        NSString *iCloudFile = [currentPage.photoPath stringByReplacingOccurrencesOfString:[icloudHelper helper].appDocumentPath withString:[icloudHelper helper].iCloudDocumentPath];
                        if( ![[NSFileManager defaultManager] removeItemAtPath:iCloudFile error:&err] ){
                            NSLog(@"remove icloud file:%@ failed, error:%@", iCloudFile, err.description);
                        }
                    }
                }];
            }
        }
        else{
            [UIView animateWithDuration:0.5 animations:^(void){
                viewFrame.origin.y = viewYStart;
                view.frame = viewFrame;
            }];
        }
    }
    else if( pgr.state == UIGestureRecognizerStateBegan )
    {
        NSLog(@"began");
        CGPoint currentPoint = [pgr translationInView:self];
        yStart = currentPoint.y;
        UIView *view = [self.pageViews objectAtIndex:self.currentIndex];
        viewYStart = view.frame.origin.y;
    }
    else if( pgr.state == UIGestureRecognizerStateChanged ){
        viewFrame.origin.y = viewYStart - (yStart - currentPoint.y);
        view.frame = viewFrame;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s",__func__);
    if( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ){
    }
    return YES;
}

@end
