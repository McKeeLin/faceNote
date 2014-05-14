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
#import "photoGroupInfoObj.h"
#import "listHeaderView.h"
#import "photoDataMgr.h"
#import "photoListCell.h"
#import "photoListheaderLayout.h"

#define CELL_ID     @"photoListCell"
#define HEAD_ID     @"headerId"

@interface albumListView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *collection;
}
@end

@implementation albumListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage blurImage:[UIImage imageNamed:@"bg"] withRadius:0.01];
        [self addSubview:imageView];
        
        CGFloat headerHeight = 140;
        listHeaderView *headerView = [[listHeaderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, headerHeight)];
        [self addSubview:headerView];
        
        photoListheaderLayout *layout = [[photoListheaderLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(frame.size.width, 30);
        layout.footerReferenceSize = CGSizeZero;
        layout.itemSize = CGSizeMake(88, 84);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headerHeight, frame.size.width, frame.size.height-headerHeight) collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = [UIColor clearColor];
        [collection registerNib:[UINib nibWithNibName:@"photoListCell" bundle:nil] forCellWithReuseIdentifier:CELL_ID];
        [collection registerNib:[UINib nibWithNibName:@"photoListSectionHeader" bundle:nil] forSupplementaryViewOfKind:@"header" withReuseIdentifier:HEAD_ID];
        [self addSubview:collection];
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [photoDataMgr manager].photoGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    photoGroupInfoObj *group = [[photoDataMgr manager].photoGroups objectAtIndex:section];
    return group.photoPaths.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    photoGroupInfoObj *group = [[photoDataMgr manager].photoGroups objectAtIndex:indexPath.section];
    NSString *photoPath = [group.photoPaths objectAtIndex:indexPath.item];
    photoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.thumbailView.image = [[photoDataMgr manager] thumbnailImageOfFile:photoPath maxPixel:88];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    photoGroupInfoObj *group = [[photoDataMgr manager].photoGroups objectAtIndex:indexPath.section];
    NSString *key = group.key;
    NSString *title = [NSString stringWithFormat:@"%@.%@.%@", [key substringToIndex:4], [key substringWithRange:NSMakeRange(4, 2)], [key substringFromIndex:6]];
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:@"header" withReuseIdentifier:HEAD_ID forIndexPath:indexPath];
    UIButton *button = (UIButton*)[headerView viewWithTag:100];
    [button setTitle:title forState:UIControlStateNormal];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

@end
