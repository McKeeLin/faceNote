//
//  tipsLabel.m
//  OA
//
//  Created by 林景隆 on 4/3/14.
//  Copyright (c) 2014 game-netease. All rights reserved.
//

#import "tipsLabel.h"

@interface tipsLabel()
{
    NSMutableDictionary *attr;
}
@end

@implementation tipsLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame text:(NSString *)text blues:(NSArray *)blues bigFontSize:(int)bigSize smallFontSize:(int)smallSize;
{
    self = [super initWithFrame:frame];
    if( self ){
        self.backgroundColor = [UIColor clearColor];
        self.textColor = UICOLOR(200, 202, 208, 1);
        self.font = [UIFont systemFontOfSize:smallSize];
        attr = [NSMutableDictionary dictionaryWithObject:UICOLOR(111, 177, 243, 1) forKey:NSForegroundColorAttributeName];
        [attr setObject:[UIFont boldSystemFontOfSize:bigSize] forKey:NSFontAttributeName];
        [self setText:text blues:blues];
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

- (void)setText:(NSString *)text blues:(NSArray *)blues
{
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    for( NSString *item in blues ){
        NSRange range = [text rangeOfString:item];
        [attrText addAttributes:attr range:range];
    }
    self.attributedText = attrText;
}

@end
