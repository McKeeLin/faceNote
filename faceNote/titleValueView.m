//
//  titleValueView.m
//  MOA
//
//  Created by cdc on 13-10-28.
//
//

#import "titleValueView.h"
#import "autoSizeLabel.h"

#define TEXT_MARGIN 5

@interface titleValueView()
{
    UILabel *titleLabel;
    autoSizeLabel *valueLabel;
}
@end

@implementation titleValueView
@synthesize height,width;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title Value:(NSString *)value
{
    self = [super initWithFrame:frame];
    if( self )
    {
        CGFloat left = TEXT_MARGIN;
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        NSString *titleContent = @"";
        if( title.length > 0 )
        {
            titleContent = [NSString stringWithFormat:@"%@：", title];
            CGSize titleSize = [titleContent sizeWithFont:font];
            CGRect titleFrame;
            titleFrame.origin.x = left;
            titleFrame.origin.y = TEXT_MARGIN;
            titleFrame.size.width = titleSize.width;
            titleFrame.size.height = titleSize.height;
            titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.font = font;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:216.00/255 green:89.00/255 blue:208.00/255 alpha:1.0];
            titleLabel.text = titleContent;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:titleLabel];
            left += titleSize.width;
        }
        
        CGRect valueFrame = frame;
        valueFrame.origin.y = TEXT_MARGIN;
        valueFrame.origin.x = left;
        valueFrame.size.width = frame.size.width - left - TEXT_MARGIN;
        valueLabel = [[autoSizeLabel alloc] initWithFrame:valueFrame font:font text:value];
        valueLabel.textAlignment = NSTextAlignmentLeft;;
        valueLabel.numberOfLines = 0;
        valueLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:77.00/255.00 green:0.0 blue:255.00/255.00 alpha:1.0];
        [self addSubview:valueLabel];
        
        height = 2 * TEXT_MARGIN + valueLabel.height;
        if( height < TITLE_VALUE_VIEW_DEFAULT_HEIGHT )
        {
            height = TITLE_VALUE_VIEW_DEFAULT_HEIGHT;
        }
        
        width = valueFrame.origin.x + valueLabel.width;
        frame.size.height = height;
        frame.size.width = width;
        self.frame = frame;
    }
    return self;
}

+ (CGSize)heightWithWidth:(CGFloat)width Title:(NSString*)title Value:(NSString*)value
{
    CGSize size = CGSizeMake(0, 0);
    CGFloat valueHeight = 2 * TEXT_MARGIN;
    CGFloat left = TEXT_MARGIN;
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    NSString *titleContent = @"";
    if( title.length > 0 )
    {
        titleContent = [NSString stringWithFormat:@"%@：", title];
        CGSize titleSize = [titleContent sizeWithFont:font];
        left = left + titleSize.width;
        size.width = left;
    }
    
    CGSize initSize = CGSizeMake(width - left - TEXT_MARGIN, 1000);
    CGSize valueSize = [value sizeWithFont:font constrainedToSize:initSize lineBreakMode:NSLineBreakByWordWrapping];
    valueHeight += valueSize.height;
    if( valueHeight < TITLE_VALUE_VIEW_DEFAULT_HEIGHT )
    {
        valueHeight = TITLE_VALUE_VIEW_DEFAULT_HEIGHT;
    }
    size.height = valueHeight;
    return size;
}

- (void)dealloc
{
    [titleLabel release];
    [valueLabel release];
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

@end
