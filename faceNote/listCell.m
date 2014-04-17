//
//  listCell.m
//  faceNote
//
//  Created by cdc on 13-11-24.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "listCell.h"
#import "albumView.h"
#import "UIApplication+appSize.h"

@interface listCell()

@property (retain) NSArray *paths;

@property (retain) albumView *amv;

@end

@implementation listCell
@synthesize paths,amv;

- (void)dealloc
{
    [paths release];
    [amv release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier album:(album *)am addr:(NSString *)addr title:(NSString *)title
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self )
    {
        /*
        self.paths = am.photos;
        CGFloat labelWidth = 100;
        CGSize appSize = [UIApplication appSize];
        CGRect albumFrame = CGRectMake(0, 10, appSize.width, ALBUMVIEW_DEFAULT_HEIGHT);
        amv = [[albumView alloc] initWithFrame:albumFrame album:am];
        [self.contentView addSubview:amv];
        
        CGRect maskFrame = CGRectMake(appSize.width - labelWidth, 10, labelWidth, albumFrame.size.height);
        UIView *mask = [[UIView alloc] initWithFrame:maskFrame];
        mask.alpha = 0.5;
        mask.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:mask];
        [mask release];
        
        if( addr.length > 0 )
        {
            CGRect tvFrame = CGRectMake(appSize.width - labelWidth, 10, labelWidth, albumFrame.size.height);
            UITextView *tv = [[UITextView alloc] initWithFrame:tvFrame];
            tv.backgroundColor = [UIColor clearColor];
            tv.font = [UIFont boldSystemFontOfSize:12];
            tv.editable = NO;
            tv.text = addr;
            tv.textColor = [UIColor whiteColor];
            tv.scrollEnabled = YES;
            [self.contentView addSubview:tv];
            [tv release];
        }
        */
        [self setAlbum:am addr:addr title:title];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setAlbum:(album *)am addr:(NSString *)addr title :(NSString *)title
{
    if( amv )
    {
        [amv removeFromSuperview];
        self.amv = nil;
    }
    self.paths = am.photos;
    CGFloat labelWidth = 100;
    CGSize appSize = [UIApplication appSize];
    CGRect albumFrame = CGRectMake(0, 2, appSize.width, ALBUMVIEW_DEFAULT_HEIGHT);
    amv = [[albumView alloc] initWithFrame:albumFrame album:am];
    [self.contentView addSubview:amv];
}

@end
