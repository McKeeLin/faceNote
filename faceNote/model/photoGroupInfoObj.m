//
//  albumnInfoObj.m
//  faceNote
//
//  Created by 林景隆 on 5/11/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "photoGroupInfoObj.h"

@implementation photoGroupInfoObj
@synthesize key, photoPaths;

- (id)init
{
    self = [super init];
    if( self ){
        photoPaths = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)dealloc
{
    [photoPaths release];
    [super dealloc];
}

@end
