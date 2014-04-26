//
//  appInfoObj.m
//  faceNote
//
//  Created by 林景隆 on 4/23/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "appInfoObj.h"

@implementation appInfoObj

+ (appInfoObj*)shareInstance
{
    static appInfoObj *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^(){
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSURL*)iCloudContainerUrl
{
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

- (NSURL*)newImageFileUrl
{
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy.MM";
    NSString *yearMonth = [fmt stringFromDate:date];
    fmt.dateFormat = @"d";
    NSString *day = [fmt stringFromDate:date];
    /*
    NSString *dir = [NSString stringWithFormat:@"%@/photos/%@/%@", self.documentPath, yearMonth, day];
    if( ![fm fileExistsAtPath:dir] )
    {
        if( ![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error] )
        {
            if( error )
            {
                NSLog(@"%s, create path failed:%@", __func__, error);
                error = nil;
            }
        }
    }
    fmt.dateFormat = @"yyyyMMddHHmmSS";
    NSString *name = [fmt stringFromDate:date];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", dir, name, FILE_TYPE];
    NSLog(@"%s,path:%@", __func__, filePath);
    if( ![fm fileExistsAtPath:self.documentPath] )
    {
        [fm createDirectoryAtPath:self.documentPath withIntermediateDirectories:NO attributes:nil error:&error];
        if( error )
        {
            NSLog(@"%s, create path failed:%@", __func__, error);
        }
    }
    */
    [fmt release];
}

@end
