//
//  dismissableTips.m
//  OA
//
//  Created by 林景隆 on 4/4/14.
//  Copyright (c) 2014 game-netease. All rights reserved.
//

#import "dismissableTips.h"
#import "tipsLabel.h"
#import <QuartzCore/QuartzCore.h>


@implementation dismissableTips

+ (void)showTips:(NSString*)tips blues:(NSArray*)blues atView:(UIView*)view seconds:(int)seconds block:(void(^)())block
{
    UIView *tipsView = [[UIView alloc] initWithFrame:view.bounds];
    tipsView.backgroundColor = [UIColor clearColor];
    tipsView.alpha = 0.99;
    [view addSubview:tipsView];
    
    CGSize initSize = CGSizeMake(view.frame.size.width * 0.8, view.frame.size.height * 0.8);
    CGSize textSize = [tips sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:initSize lineBreakMode:NSLineBreakByWordWrapping];
    UIView *tipsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textSize.width+20, textSize.height+40)];
    tipsBackgroundView.center = view.center;
    tipsBackgroundView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    tipsBackgroundView.layer.borderWidth = 1.5;
    tipsBackgroundView.layer.cornerRadius = 4;
    tipsBackgroundView.layer.borderColor = UICOLOR(87, 148, 239, 1).CGColor;
    [tipsView addSubview:tipsBackgroundView];
    
    CGRect labelFrame = CGRectMake((tipsBackgroundView.frame.size.width-textSize.width)/2, (tipsBackgroundView.frame.size.height-textSize.height)/2, textSize.width, textSize.height);
    tipsLabel *label = [[tipsLabel alloc] initWithFrame:labelFrame text:tips blues:blues bigFontSize:14 smallFontSize:13];
    label.numberOfLines = 0;
    [tipsBackgroundView addSubview:label];
    
    CATransform3D transform = tipsBackgroundView.layer.transform;
    [UIView animateWithDuration:0.5 animations:^(){
        tipsBackgroundView.layer.transform = CATransform3DScale(transform, 1.2, 1.2, 1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.5 animations:^(){
            tipsBackgroundView.layer.transform = transform;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.5 animations:^(){
                tipsView.alpha = 1;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:seconds animations:^(){
                    tipsView.alpha = 0;
                }completion:^(BOOL finished){
                    [tipsView removeFromSuperview];
                    if( block ){
                        block();
                    }
                }];
            }];
        }];
    }];
}

@end
