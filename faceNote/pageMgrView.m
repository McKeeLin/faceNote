//
//  pageMgrView.m
//  faceNote
//
//  Created by cdc on 13-11-5.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "pageMgrView.h"
#import "UIImage+blur.h"
#import "photoView.h"

@interface pageMgrView()
{
    CGFloat width;
    CGFloat height;
    UIImageView *bgiv;
    UIImageView *under;
}


@end

@implementation pageMgrView
@synthesize pageViews,delegate,currentIndex;

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
    self = [super initWithFrame:frame];
    if( self )
    {
        self.backgroundColor = [UIColor whiteColor];
        width = frame.size.width;
        height = frame.size.height;
        under = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:under];
        bgiv = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:bgiv];
        self.pageViews = [[NSMutableArray alloc] initWithArray:views];
        self.delegate = dele;
        currentIndex = index;
        CGFloat horMargin = width / 20;
        CGFloat verMargin = height / 20;
        CGRect pageFrame = CGRectMake(horMargin, verMargin, width - 2 * horMargin, height - 2 * verMargin);
        photoView *currentPage = [self.pageViews objectAtIndex:index];
        currentPage.frame = pageFrame;
        [self addSubview:currentPage];
        UIImage *viewImg = [UIImage scaleFrom:[UIImage imageWithContentsOfFile:currentPage.photoPath] width:width height:height];
        UIImage *glassImg = [UIImage blurImage:viewImg withRadius:0.5];
        
        bgiv.image = glassImg;
        
        CGFloat left = -width;
        for( NSInteger i = index - 1; i >= 0; i-- )
        {
            UIView *page = [self.pageViews objectAtIndex:i];
            page.frame = CGRectMake(left + horMargin, verMargin, width - 2 * horMargin, height - 2 * verMargin);
            [self addSubview:page];
            left -=width;
        }
        left = width;
        for( NSInteger i = index + 1; i < self.pageViews.count; i++ )
        {
            UIView *page = [self.pageViews objectAtIndex:i];
            page.frame = CGRectMake(left + horMargin, verMargin, width - 2 * horMargin, height - 2 * verMargin);
            [self addSubview:page];
            left += width;
        }
        UISwipeGestureRecognizer *rsgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGestureAction:)];
        rsgr.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rsgr];
        [rsgr release];
        
        UISwipeGestureRecognizer *lsgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGestureAction:)];
        lsgr.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:lsgr];
        [lsgr release];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [pageViews release];
    [delegate release];
    [bgiv release];
    [under release];
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

- (void)rightSwipeGestureAction:(UISwipeGestureRecognizer*)recognizer
{
    if( pageViews.count == 0 ){
        return;
    }
    
    if( recognizer.direction == UISwipeGestureRecognizerDirectionRight )
    {
        if( currentIndex > 0 && currentIndex )
        {
            CGFloat dismissWidth = width * 0.7;
            CGFloat dismissHeight = height * 0.7;
            CGFloat displayWidth = width * 0.9;
            CGFloat displayHeitht = height * 0.9;
            photoView *displayView = (photoView*)[pageViews objectAtIndex:currentIndex - 1];
            photoView *dismissView = (photoView*)[pageViews objectAtIndex:currentIndex];
            displayView.frame = CGRectMake(-width+(width-dismissWidth)/2, (height-dismissHeight)/2, dismissWidth, dismissHeight);
            UIImage *displayImg = [UIImage scaleFrom:[UIImage imageWithContentsOfFile:displayView.photoPath] width:width height:height];
            under.image = bgiv.image;
            bgiv.image = [UIImage blurImage:displayImg withRadius:0.3];
            bgiv.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^(){
                displayView.frame = CGRectMake((width-displayWidth)/2, (height-displayHeitht)/2, displayWidth, displayHeitht);
                dismissView.frame = CGRectMake(width+((width-dismissWidth)/2), (height-dismissHeight)/2, dismissWidth, dismissHeight);
                bgiv.alpha = 1.0;
            }];
            currentIndex--;
            if( [delegate respondsToSelector:@selector(didShowPage:atIndex:)] )
            {
                [delegate didShowPage:displayView atIndex:currentIndex];
            }
        }        
        else if( currentIndex == 0 )
        {
            if( [delegate respondsToSelector:@selector(willOverLowbound)] )
            {
                [delegate willOverLowbound];
            }
        }
    }
}

- (void)leftSwipeGestureAction:(UISwipeGestureRecognizer*)recognizer
{
    if( pageViews.count == 0 ){
        return;
    }
    
    if( recognizer.direction == UISwipeGestureRecognizerDirectionLeft )
    {
        if( currentIndex < pageViews.count - 1 && currentIndex >= 0 )
        {
            CGFloat dismissWidth = width * 0.7;
            CGFloat dismissHeight = height * 0.7;
            CGFloat displayWidth = width * 0.9;
            CGFloat displayHeitht = height * 0.9;
            photoView *displayView = (photoView*)[pageViews objectAtIndex:currentIndex + 1];
            photoView *dismissView = (photoView*)[pageViews objectAtIndex:currentIndex];
            displayView.frame = CGRectMake(width+(width-dismissWidth)/2, (height-dismissHeight)/2, dismissWidth, dismissHeight);
            UIImage *displayImg = [UIImage scaleFrom:[UIImage imageWithContentsOfFile:displayView.photoPath] width:width height:height];
            under.image = bgiv.image;
            bgiv.image = [UIImage blurImage:displayImg withRadius:0.3];
            bgiv.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^(){
                displayView.frame = CGRectMake((width-displayWidth)/2, (height-displayHeitht)/2, displayWidth, displayHeitht);
                dismissView.frame = CGRectMake(-width+(width-dismissWidth)/2, (height-dismissHeight)/2, dismissWidth, dismissHeight);
                bgiv.alpha = 1.0;
            }];
            currentIndex++;
            if( [delegate respondsToSelector:@selector(didShowPage:atIndex:)] )
            {
                [delegate didShowPage:displayView atIndex:currentIndex];
            }
        }
        else if( currentIndex == pageViews.count - 1 )
        {
            if( [delegate respondsToSelector:@selector(willOverUpbound)] )
            {
                [delegate willOverUpbound];
            }
        }
    }
}



@end
