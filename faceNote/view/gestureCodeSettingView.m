//
//  gestureCodeSettingView.m
//  OA
//
//  Created by 林景隆 on 14-3-17.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "gestureCodeSettingView.h"
#import "SPLockScreen.h"
#import "UICKeyChainStore.h"

@interface gestureCodeSettingView()<LockScreenDelegate>
{
    UILabel *infoLabel;
    SPLockScreen *lockScreen;
    int orginalCode;
    int code;
}
@end

@implementation gestureCodeSettingView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id)dele
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.text = NSLocalizedString(@"SetGestureCode", nil);
        delegate = dele;
        orginalCode = 0;
        code = 0;
        CGRect infoFrame = CGRectMake(0, 20, frame.size.width, 44);
        infoLabel = [[UILabel alloc] initWithFrame:infoFrame];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.font = [UIFont boldSystemFontOfSize:14];
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.content addSubview:infoLabel];
        
        NSString *codeString = [UICKeyChainStore stringForKey:SETTING_GESTURE_CODE];
        if( codeString ){
            orginalCode = codeString.intValue;
            infoLabel.text = NSLocalizedString(@"OriginalGestureCode", nil);
        }
        else{
            infoLabel.text = NSLocalizedString(@"inputGestureCode", nil);
        }
        
        CGRect lockScreenFrame = CGRectMake(0, infoFrame.size.height + 20, 320, self.content.frame.size.height-infoFrame.size.height);
        lockScreen = [[SPLockScreen alloc] initWithFrame:lockScreenFrame];
        lockScreen.delegate = self;
        [self.content addSubview:lockScreen];
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

- (void)lockScreen:(SPLockScreen *)screen didEndWithPattern:(NSNumber *)patternNumber
{
    int newCode = patternNumber.intValue;
    if( orginalCode == 0 ){
        if( code == 0 ){
            code = newCode;
            infoLabel.text = NSLocalizedString(@"GestureCodeAgain", nil);
        }
        else{
            if( code == newCode ){
                infoLabel.text = @"";
                if( delegate && [delegate respondsToSelector:@selector(didGestureCodePass:)] ){
                    [delegate didGestureCodePass:[NSString stringWithFormat:@"%d",code]];
                }
                [self.backButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            else{
                infoLabel.text = NSLocalizedString(@"gestureCodeNotRightInputAgain", nil);
            }
        }
    }
    else{
        if( orginalCode == newCode ){
            orginalCode = 0;
            infoLabel.text = NSLocalizedString(@"inputGestureCode", nil);
        }
        else{
            infoLabel.text = NSLocalizedString(@"OriginalGestureCodeNotRight", nil);
        }
    }
}


@end
