//
//  dismissableTips.h
//  OA
//
//  Created by 林景隆 on 4/4/14.
//  Copyright (c) 2014 game-netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dismissableTips : NSObject

+ (void)showTips:(NSString*)tips blues:(NSArray*)blues atView:(UIView*)view seconds:(int)seconds block:(void(^)())block;

@end
