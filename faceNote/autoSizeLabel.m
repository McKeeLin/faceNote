//
//  autoSizeLabel.m
//  MOA
//
//  Created by cdc on 13-11-16.
//
//

#import "autoSizeLabel.h"

@implementation autoSizeLabel
@synthesize height,width;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (id)initWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if( self )
    {
        CGSize initSize = CGSizeMake(frame.size.width, 1000);
        CGSize textSize = [text sizeWithFont:font constrainedToSize:initSize lineBreakMode:NSLineBreakByWordWrapping];
        CGRect newFrame = frame;
        if( frame.size.width > textSize.width )
        {
            frame.size.width = textSize.width;
        }
        newFrame.size.height = textSize.height;
        self.numberOfLines = 0;
        self.font = font;
        self.backgroundColor = [UIColor clearColor];
        self.text = text;
        height = textSize.height;
        width = textSize.width;
        self.frame = newFrame;
    }
    
    return self;
}

- (CGSize)sizeWidth:(CGFloat)w Font:(UIFont *)font text:(NSString *)text
{
    CGSize initSize = CGSizeMake(w, 1000);
    CGSize textSize = [text sizeWithFont:font constrainedToSize:initSize lineBreakMode:NSLineBreakByWordWrapping];
    return textSize;
}

@end
