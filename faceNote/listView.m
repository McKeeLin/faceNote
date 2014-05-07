//
//  listView.m
//  faceNote
//
//  Created by cdc on 13-11-6.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "listView.h"
#import "def.h"
#import "UIApplication+appSize.h"
#import "albumView.h"
#import "listCell.h"
#import "album.h"
#import "albumGroup.h"
#import "ViewController.h"
#import "listToolBar.h"
#import "dismissableTips.h"
#import <QuartzCore/QuartzCore.h>
#import "icloudHelper.h"
#import "MBProgressHUD.h"
#import "iAPHelper.h"

#define HEADERVIEW_HEIGHT   50

@interface listView()
{
    NSMutableArray *imgViews;
    UITableView *table;
    NSMutableArray *groups;
}
@end

@implementation listView
@synthesize vc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:247.0/255.0];
        CGSize size = frame.size;
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.dataSource = self;
        table.delegate = self;
        [self addSubview:table];
        groups = [[NSMutableArray alloc] initWithCapacity:0];
        
        imgViews = [[NSMutableArray alloc] initWithCapacity:0];
        
        /*
        CGRect toolBarFrame;
        toolBarFrame.origin.x = 0;
        toolBarFrame.origin.y = size.height - 40;
        toolBarFrame.size.height = 40;
        toolBarFrame.size.width = size.width;
        listToolBar *bar = [[listToolBar alloc] initWithFrame:toolBarFrame];
        [self addSubview:bar];
        [bar release];
        */
        UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeToLeft:)];
        sgr.numberOfTouchesRequired = 1;
        sgr.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:sgr];
    }
    return self;
}

- (void)dealloc
{
    [imgViews release];
    [table release];
    [groups release];
    [vc release];
    [super dealloc];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"listViewShown";
    BOOL shown = [defaults boolForKey:key];
    if( !shown )
    {
        [defaults setBool:YES forKey:key];
        NSString *tips = @"1.向左滑动可切换一照相视图\n\n2.点击缩略图可浏览照片";//@"1.swipe to left to switch the camera view \n\n2.tap the picture nail to browse the album.";
        [dismissableTips showTips:tips blues:[NSArray arrayWithObject:tips] atView:self seconds:10 block:nil];
    }
    
    NSLog(@"%s", __func__);
    if( newSuperview ){
        if( [iAPHelper helper].bPurchased ){
            NSFileManager *fm = [NSFileManager defaultManager];
            NSArray *subs = [fm subpathsAtPath:[icloudHelper helper].iCloudDocumentPath];
            for( NSString *sub in subs){
                NSString *iCloudPath = [[icloudHelper helper].iCloudDocumentPath stringByAppendingPathComponent:sub];
                NSString *localPath = [iCloudPath stringByReplacingOccurrencesOfString:[icloudHelper helper].iCloudDocumentPath withString:[icloudHelper helper].appDocumentPath];
                BOOL isDir = NO;
                [fm fileExistsAtPath:iCloudPath isDirectory:&isDir];
                NSError *err;
                if( ![fm fileExistsAtPath:localPath] ){
                    if( isDir ){
                        if( ![fm createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:&err] ){
                            NSLog(@"%s, create path %@ failed, error:%@", __func__, localPath, err.localizedDescription);
                        }
                    }
                    else{
                        NSRange r = [localPath rangeOfString:FILE_TYPE];
                        if( r.location != NSNotFound ){
                            if( [fm isReadableFileAtPath:iCloudPath] )
                            {
                                if( ![fm copyItemAtPath:iCloudPath toPath:localPath error:&err] ){
                                    NSLog(@"%s, copy %@ to %@ failed, %@", __func__, iCloudPath, localPath, err.localizedDescription);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        [self loadImages];
    }
}


- (void)didMoveToSuperview
{
}

- (void)loadImages
{
    //
    [[icloudHelper helper] queryGroups];
    [groups removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSURL *containerUrl = [icloudHelper helper].containerUrl;
    NSString *containerPath = [containerUrl path];
    NSString *photosDir = [NSString stringWithFormat:@"%@/Documents/photos",containerPath];
    photosDir = [[icloudHelper helper].appDocumentPath stringByAppendingPathComponent:@"photos"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *yearMonths = [fm subpathsAtPath:photosDir];
    for( NSString * yearMonth in yearMonths )
    {
        NSRange r = [yearMonth rangeOfString:@"/"];
        if( r.location != NSNotFound )
        {
            continue;
        }
        
        NSRange r1 = [yearMonth rangeOfString:@"."];
        if( r1.location == 0 )
        {
            continue;
        }
        albumGroup *group = [[albumGroup alloc] init];
        group.title = yearMonth;
        NSString *yearMonthDir = [NSString stringWithFormat:@"%@/%@", photosDir, yearMonth];
        group.path = yearMonthDir;
        NSArray *days = [fm subpathsAtPath:yearMonthDir];
        for( NSString *day in days )
        {
            NSRange rr = [day rangeOfString:@"/"];
            if( rr.location != NSNotFound )
            {
                continue;
            }
            NSRange rr2 = [day rangeOfString:@"."];
            if( rr2.location == 0 )
            {
                continue;
            }
            album *am = [[album alloc] init];
            am.title = day;
            NSString *dayDir = [NSString stringWithFormat:@"%@/%@", yearMonthDir, day];
            am.path = dayDir;
            
            NSArray *photos = [fm subpathsAtPath:dayDir];
            for( NSString *photo in photos )
            {
                NSRange rr3 = [photo rangeOfString:@"."];
                if( rr3.location == 0 )
                {
                    continue;
                }
                NSString *img = [NSString stringWithFormat:@"%@/%@", dayDir, photo];
                [am.photos addObject:img];
            }
            
            if( am.photos.count > 0 )
            {
                [am.photos sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
                 {
                     NSString *img1 = (NSString*)obj1;
                     NSString *img2 = (NSString*)obj2;
                     NSDate *date1 = [self getFileModifiedDate:img1];
                     NSDate *date2 = [self getFileModifiedDate:img2];
                     NSDate *earlierDate = [date1 earlierDate:date2];
                     if( earlierDate == date1 )
                     {
                         return (NSComparisonResult)NSOrderedDescending;
                     }
                     else
                     {
                         return (NSComparisonResult)NSOrderedAscending;
                     }
                 }];
                
                [group.albums addObject:am];
                [group.albums sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
                 {
                     album *a1 = (album*)obj1;
                     album *a2 = (album*)obj2;
                     NSDate *date1 = [self getFileModifiedDate:a1.path];
                     NSDate *date2 = [self getFileModifiedDate:a2.path];
                     NSDate *earlierDate = [date1 earlierDate:date2];
                     if( earlierDate == date1 )
                     {
                         return (NSComparisonResult)NSOrderedDescending;
                     }
                     else
                     {
                         return (NSComparisonResult)NSOrderedAscending;
                     }
                 }];
            }
            [am release];
                
        }
        
        if( group.albums.count > 0 ){
            [groups addObject:group];
            [groups sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
                albumGroup *a1 = (albumGroup*)obj1;
                albumGroup *a2 = (albumGroup*)obj2;
                NSDate *date1 = [self getFileModifiedDate:a1.path];
                NSDate *date2 = [self getFileModifiedDate:a2.path];
                NSDate *earlierDate = [date1 earlierDate:date2];
                if( earlierDate == date1 )
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }];
        }
        [group release];
    }
    
    [table reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    albumGroup *group = [groups objectAtIndex:section];
    return group.albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALBUMVIEW_DEFAULT_HEIGHT+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADERVIEW_HEIGHT;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    albumGroup *group = [groups objectAtIndex:indexPath.section];
    album *am = [group.albums objectAtIndex:indexPath.row];
    NSString *Id = [NSString stringWithFormat:@"%@.%@", group.title, am.title];
    listCell* cell = (listCell*)[tableView dequeueReusableCellWithIdentifier:Id];
    if( !cell )
    {
        cell = [[[listCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id album:am addr:@"" title:@""] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        [cell setAlbum:am addr:@"" title:@""];
    }
    return (UITableViewCell*)cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    albumGroup *group = [groups objectAtIndex:section];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, HEADERVIEW_HEIGHT)] autorelease];
    CGSize initSize = CGSizeMake(320, 20);
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    CGSize textSize = [group.title sizeWithFont:font constrainedToSize:initSize lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect frame = CGRectMake((tableView.frame.size.width-textSize.width-10)/2, HEADERVIEW_HEIGHT-textSize.height-7, textSize.width+10, textSize.height+2);
    UILabel *title = [[[UILabel alloc] initWithFrame:frame] autorelease];
    title.backgroundColor = [UIColor grayColor];
    title.text = group.title;
    title.textColor = [UIColor whiteColor];
    title.font = font;
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.cornerRadius = 8;
    title.layer.masksToBounds = YES;
    [headerView addSubview:title];
    return headerView;
}

- (NSInteger)getFileModifiedTime:(NSString*)path
{
    NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attr = [fm attributesOfItemAtPath:path error:&err];
    NSDate *date = (NSDate*)[attr objectForKey:NSFileModificationDate];
    return [date timeIntervalSince1970];
    
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:date];
    NSDate *date2 = [NSDate dateWithTimeInterval:seconds sinceDate:date];
    NSInteger seconds2 = [date2 timeIntervalSince1970];
    return seconds2;
}

- (NSDate*)getFileModifiedDate:(NSString*)path
{
    NSError *err;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attr = [fm attributesOfItemAtPath:path error:&err];
    NSDate *date = (NSDate*)[attr objectForKey:NSFileModificationDate];
    return date;
}

- (void)onTouchCamera:(id)sender
{
    [vc showCameraFromListView];
    [self removeFromSuperview];
}

- (void)onSwipeToLeft:(UISwipeGestureRecognizer*)sgr
{
    [vc showCameraFromListView];
    [self removeFromSuperview];
}

@end
