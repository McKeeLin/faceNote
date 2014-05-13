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
        imageView.image = [UIImage blurImage:[UIImage imageNamed:@"effier.jpg"] withRadius:0.01];
        [self addSubview:imageView];
        
        CGFloat headerHeight = 140;
        listHeaderView *headerView = [[listHeaderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, headerHeight)];
        [self addSubview:headerView];
        
        UICollectionViewFlowLayout *layout;
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
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

@end
