//
//  gestureCodeVerifyView.h
//  OA
//
//  Created by 林景隆 on 14-3-18.
//  Copyright (c) 2014年 game-netease. All rights reserved.
//

#import "topbarView.h"

/**
 *  <#Description#>
 */
@protocol gestureCodeVerifyViewDelegate <NSObject>

/**
 *  <#Description#>
 *
 *  @param code <#code description#>
 */
- (void)didGestureCodeIsValid:(NSString*)code;

/**
 *  <#Description#>
 *
 *  @param times <#times description#>
 */
- (void)didInvalidGestureCodeReachLimitTimes:(int)times;

@end



/**
 *  <#Description#>
 */
@interface gestureCodeVerifyView : topbarView


/**
 *  <#Description#>
 *
 *  @param frame <#frame description#>
 *  @param limit <#limit description#>
 *  @param dele  <#dele description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame code:(NSString*)codeString limit:(int)limit delegate:(id)dele;

@end
