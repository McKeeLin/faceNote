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
        self.backgroundColor = [UIColor redColor];
        CGSize size = [UIApplication appSize];
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.dataSource = self;
        table.delegate = self;
        [self addSubview:table];
        groups = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadImages];
        
        imgViews = [[NSMutableArray alloc] initWithCapacity:0];
        
        CGRect toolBarFrame;
        toolBarFrame.origin.x = 0;
        toolBarFrame.origin.y = size.height - 40;
        toolBarFrame.size.height = 40;
        toolBarFrame.size.width = size.width;
        listToolBar *bar = [[listToolBar alloc] initWithFrame:toolBarFrame];
        [self addSubview:bar];
        [bar release];
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
    ;
}

- (void)loadImages
{
    [groups removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *photosDir = [NSString stringWithFormat:@"%@/photos", documentPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *yearMonths = [fm subpathsAtPath:photosDir];
    for( NSString * yearMonth in yearMonths )
    {
        NSRange r = [yearMonth rangeOfString:@"/"];
        if( r.location != NSNotFound )
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
            album *am = [[album alloc] init];
            am.title = day;
            NSString *dayDir = [NSString stringWithFormat:@"%@/%@", yearMonthDir, day];
            am.path = dayDir;
            
            NSArray *photos = [fm subpathsAtPath:dayDir];
            for( NSString *photo in photos )
            {
                NSString *img = [NSString stringWithFormat:@"%@/%@", dayDir, photo];
                [am.photos addObject:img];
            }
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
            [am release];
                
        }
        
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
    return ALBUMVIEW_DEFAULT_HEIGHT + 10;
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
    CGRect frame = CGRectMake(10, 0, 320, 20);
    UILabel *title = [[[UILabel alloc] initWithFrame:frame] autorelease];
    title.backgroundColor = [UIColor clearColor];
    title.text = group.title;
    title.textColor = [UIColor grayColor];
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textAlignment = NSTextAlignmentLeft;
    return title;
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

@end
