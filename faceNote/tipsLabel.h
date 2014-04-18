//
//  tipsLabel.h
//  OA
//
//  Created by 林景隆 on 4/3/14.
//  Copyright (c) 2014 game-netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tipsLabel : UILabel

- (id)initWithFrame:(CGRect)frame text:(NSString*)text blues:(NSArray*)blues bigFontSize:(int)bigSize smallFontSize:(int)smallSize;

- (void)setText:(NSString *)text blues:(NSArray *)blues;

@end
