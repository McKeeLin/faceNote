//
//  gestureCodeVerifyView.m
//  OA
//
//  Created by 林景隆 on 14-3-18.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "gestureCodeVerifyView.h"
#import "SPLockScreen.h"
#import "UICKeyChainStore.h"

@interface gestureCodeVerifyView()<LockScreenDelegate>
{
    __weak id<gestureCodeVerifyViewDelegate> delegate;
    int limitTimes;
    int invalidTimes;
    UILabel *infoLabel;
    SPLockScreen *lockScreen;
    int code;
}
@end

@implementation gestureCodeVerifyView

- (id)initWithFrame:(CGRect)frame code:(NSString *)codeString limit:(int)limit delegate:(id)dele back:(BOOL)backEnable
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        limitTimes = limit;
        invalidTimes = 0;
        delegate = dele;
        self.titleLabel.text = NSLocalizedString(@"gestureCodeVerifyCation", nil);
        CGRect infoFrame = CGRectMake(0, 20, frame.size.width, 44);
        infoLabel = [[UILabel alloc] initWithFrame:infoFrame];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.font = [UIFont boldSystemFontOfSize:14];
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.text = NSLocalizedString(@"inputGestureCode", nil);
        [self.content addSubview:infoLabel];
        
        if( codeString ){
            code = codeString.intValue;
        }
        
        CGRect lockScreenFrame = CGRectMake(0, infoFrame.size.height+20, 320, self.content.frame.size.height-infoFrame.size.height);
        lockScreen = [[SPLockScreen alloc] initWithFrame:lockScreenFrame];
        lockScreen.delegate = self;
        [self.content addSubview:lockScreen];
        
        if( !backEnable ){
            self.backButton.hidden = YES;
        }
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

- (void)lockScreen:(SPLockScreen *)lockScreen didEndWithPattern:(NSNumber *)patternNumber
{
    if( patternNumber.intValue == code ){
        if( delegate && [delegate respondsToSelector:@selector(didGestureCodeIsValid:)] ){
            [delegate didGestureCodeIsValid:[NSString stringWithFormat:@"%d", code]];
        }
        [self.backButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else{
        invalidTimes++;
        if( invalidTimes == limitTimes ){
            if( delegate && [delegate respondsToSelector:@selector(didInvalidGestureCodeReachLimitTimes:)] ){
                [delegate didInvalidGestureCodeReachLimitTimes:limitTimes];
            }
            [self.backButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else{
            infoLabel.text = NSLocalizedString(@"gestureCodeNotRightInputAgain", nil);
        }
    }
}

@end
