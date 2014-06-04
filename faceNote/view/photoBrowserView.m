//
//  photoBrowserView.m
//  OA
//
//  Created by 林景隆 on 6/4/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "photoBrowserView.h"
#import "photoScaleView.h"
#import "iAPHelper.h"
#import "icloudHelper.h"

@interface photoBrowserView() <UIGestureRecognizerDelegate>
{
    CGFloat yStart;
    CGFloat viewYStart;
    CGRect originalFrame;
}
@end

@implementation photoBrowserView

- (id)initWithFrame:(CGRect)frame photoGroup:(photoGroupInfoObj *)group defaultIndex:(NSInteger)index delegate:(id)dele
{
    NSMutableArray *subViews = [NSMutableArray arrayWithCapacity:0];
    for( NSString *photoPath in group.photoPaths ){
        photoScaleView *subView = [[photoScaleView alloc] initWithFrame:CGRectZero photoPath:photoPath];
        [subViews addObject:subView];
        [subView release];
    }
    
    self = [super initWithFrame:frame subViews:subViews defaultIndex:index delegate:dele];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *dragUpGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onDragUp:)];
        dragUpGesture.delegate = self;
        [dragUpGesture requireGestureRecognizerToFail:self.rsgr];
        [dragUpGesture requireGestureRecognizerToFail:self.lsgr];
        [self addGestureRecognizer:dragUpGesture];
        UIView *currentPage = [self.pageViews objectAtIndex:self.currentIndex];
        originalFrame = currentPage.frame;
        [dragUpGesture release];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        tgr.numberOfTapsRequired = 1;
        tgr.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tgr];
        [tgr release];
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

- (void)onDragUp:(UIPanGestureRecognizer*)pgr
{
    NSLog(@"%s",__func__);
    if( self.pageViews.count == 0 ){
//        [[ViewController defaultVC] showListFromPhotoView];
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
            photoScaleView *currentPage = (photoScaleView*)[self.pageViews objectAtIndex:self.currentIndex];
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
                    else{
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

- (void)onTap:(UITapGestureRecognizer*)tgr
{
    ;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ){
    }
    return YES;
}

@end
