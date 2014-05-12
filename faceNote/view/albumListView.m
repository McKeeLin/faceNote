//
//  albumListView.m
//  faceNote
//
//  Created by 林景隆 on 5/11/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "albumListView.h"
#import "UIImage+blur.h"
#import "icloudHelper.h"
#import "albumInfoObj.h"
#import "listHeaderView.h"

@interface albumListView()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *albumInfos;
    UITableView *table;
    UICollectionView *collection;
}
@end

@implementation albumListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        albumInfos = [[NSMutableArray alloc] initWithCapacity:0];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage blurImage:[UIImage imageNamed:@"effier.jpg"] withRadius:0.01];
        [self addSubview:imageView];
        
        CGFloat headerHeight = 140;
        listHeaderView *headerView = [[listHeaderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, headerHeight)];
        [self addSubview:headerView];
        
        UICollectionViewFlowLayout *layout;
    }
    return self;
}

- (void)loadData
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *photoDir = [[icloudHelper helper].appDocumentPath stringByAppendingPathComponent:PHOTO_DIR_NAME];
    NSArray *subPaths = [fm subpathsAtPath:photoDir];
    for( NSString *subPath in subPaths ){
        NSRange r = [subPath rangeOfString:PHOTO_FILE_TYPE];
        if( r.location != NSNotFound )
        {
            NSString *filePath = [photoDir stringByAppendingPathComponent:subPath];
            NSString *key = [subPath substringToIndex:r.location - 7];
            NSLog(@".....................%@",key);
            BOOL keyFound = NO;
            for( albumInfoObj *info in albumInfos ){
                if( [info.key isEqualToString:key] ){
                    for( NSString *photoPath in info.photoPaths )
                    {
                        NSRange r2 = [photoPath rangeOfString:subPath];
                        if( r2.location == NSNotFound ){
                            [info.photoPaths addObject:filePath];
                        }
                    }
                    keyFound = YES;
                    break;
                }
            }
            
            if( !keyFound ){
                albumInfoObj *albumInfo = [[albumInfoObj alloc] init];
                albumInfo.key = key;
                [albumInfo.photoPaths addObject:filePath];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return albumInfos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"albumListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if( !cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( editingStyle == UITableViewCellEditingStyleDelete ){
        ;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

@end
