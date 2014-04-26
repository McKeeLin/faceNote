//
//  myDocument.m
//  faceNote
//
//  Created by 林景隆 on 4/25/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "myDocument.h"

@implementation myDocument
@synthesize data;

- (void)dealloc
{
    [data release];
    [super dealloc];
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return data;
}

@end
