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
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_ID     @"photoListCell"
#define HEAD_ID     @"headerId"

@interface albumListView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *collection;
    listHeaderView *headerView;
}
@end

@implementation albumListView
@synthesize vc;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage blurImage:[UIImage imageNamed:@"bg"] withRadius:0.01];
        [self addSubview:imageView];
        
        CGFloat headerHeight = 140;
        headerView = [[listHeaderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, headerHeight)];
        [self addSubview:headerView];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(frame.size.width, 30);
        layout.footerReferenceSize = CGSizeZero;
        layout.itemSize = CGSizeMake(88, 84);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headerHeight, frame.size.width, frame.size.height-headerHeight) collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = [UIColor clearColor];
        [collection registerNib:[UINib nibWithNibName:@"photoListCell" bundle:nil] forCellWithReuseIdentifier:CELL_ID];
        [collection registerNib:[UINib nibWithNibName:@"photoListSectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD_ID];
        [self addSubview:collection];
        
        UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeoLeft:)];
        sgr.numberOfTouchesRequired = 1;
        sgr.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:sgr];
        [sgr release];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [headerView release];
    [vc release];
    [collection release];
    [super dealloc];
}

- (void)loadImages
{
    [collection reloadData];
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
    cell.thumbailView.image =[[photoDataMgr manager] thumbnailImageOfFile:photoPath maxPixel:88];// [UIImage imageWithContentsOfFile:photoPath];//
    cell.thumbailView.layer.contentsGravity = kCAGravityResizeAspectFill;
    cell.thumbailView.layer.masksToBounds = YES;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if( [kind isEqualToString:UICollectionElementKindSectionHeader] ){
        photoGroupInfoObj *group = [[photoDataMgr manager].photoGroups objectAtIndex:indexPath.section];
        NSString *key = group.key;
        NSString *title = [NSString stringWithFormat:@"%@.%@.%@", [key substringToIndex:4], [key substringWithRange:NSMakeRange(4, 2)], [key substringFromIndex:6]];
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD_ID forIndexPath:indexPath];
        UIButton *button = (UIButton*)[headerView viewWithTag:100];
        [button setTitle:title forState:UIControlStateNormal];
        return headerView;
    }
    else{
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    photoGroupInfoObj *group = [[photoDataMgr manager].photoGroups objectAtIndex:indexPath.section];
    NSString *photoPath = [group.photoPaths objectAtIndex:indexPath.item];
}

- (void)onTouchCamera:(id)sender
{
    ;
}

- (void)onTouchSetting:(id)sender
{
    ;
}

- (void)onSwipeoLeft:(UISwipeGestureRecognizer*)sgr
{
    [vc showCameraFromListView];
    vc.cameraView.photoType = PHOTO_NORMAL;
}

@end
