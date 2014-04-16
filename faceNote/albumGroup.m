//
//  albumGroup.m
//  faceNote
//
//  Created by cdc on 13-11-25.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "albumGroup.h"

@implementation albumGroup
@synthesize title, path, albums;

- (id)init
{
    self = [super init];
    if( self )
    {
        albums = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [title release];
    [path release];
    [albums release];
    [super dealloc];
}

@end
