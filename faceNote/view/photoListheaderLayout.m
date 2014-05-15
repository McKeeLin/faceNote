//
//  photoListheaderLayout.m
//  OA
//
//  Created by 林景隆 on 5/14/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "photoListheaderLayout.h"


@interface photoListheaderLayout()
{
    UICollectionViewLayoutAttributes *attributes;
}
@end

@implementation photoListheaderLayout

- (id)init
{
    self = [super init];
    if( self ){
        attributes = [[UICollectionViewLayoutAttributes alloc] init];
        attributes.size = CGSizeMake(320, 30);
        attributes.frame = CGRectMake(0, 0, 320, 30);
    }
    return self;
}

- (void)dealloc
{
    [attributes release];
    [super dealloc];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"header" withIndexPath:indexPath];
    attr.size = CGSizeMake(320, 30);
    attr.frame = CGRectMake(0, 0, 320, 30);
    return attr;
}

@end
