//
//  album.m
//  faceNote
//
//  Created by cdc on 13-11-25.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "album.h"

@implementation album
@synthesize title,path,photos;

- (id)init
{
    self = [super init];
    if( self )
    {
        photos = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  self;
}

- (void)dealloc
{
    [title release];
    [path release];
    [photos release];
    [super dealloc];
}

@end
