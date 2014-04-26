//
//  icloudHelper.m
//  faceNote
//
//  Created by 林景隆 on 4/23/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "icloudHelper.h"
#import "myDocument.h"


@interface icloudHelper()<NSMetadataQueryDelegate>
{
    __strong NSMetadataQuery *query;
}
@property (retain) NSURL *containerUrl;
@end

@implementation icloudHelper
@synthesize containerUrl;

+ (icloudHelper*)helper
{
    static icloudHelper *helper = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(){
        helper = [[icloudHelper alloc] init];
    });
    return helper;
}

- (id)init
{
    self = [super init];
    if( self )
    {
        query = [[NSMetadataQuery alloc] init];
        [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        query.delegate = self;
        query.predicate = [NSPredicate predicateWithFormat:@"%K like '*'", NSMetadataItemPathKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGatheringDidStart:) name:NSMetadataQueryDidStartGatheringNotification object:query];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGatheringProgress:) name:NSMetadataQueryGatheringProgressNotification object:query];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onQueryDidUpdate:) name:NSMetadataQueryDidUpdateNotification object:query];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGatheringFinished:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
        [self isEnable];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [query release];
    [containerUrl release];
    [super dealloc];
}

- (void)queryGroups
{
    [query startQuery];
}

/*
 url:file:///Users/game-netease/Library/Application%20Support/iPhone%20Simulator/7.1/Library/Mobile%20Documents/D9KLEDDTR3~com~mckeelin~facenote/
 url:file:///private/var/mobile/Library/Mobile%20Documents/D9KLEDDTR3~com~mckeelin~facenote/
 */
- (BOOL)isEnable
{
    NSString *Id = [NSString stringWithFormat:@"D9KLEDDTR3.%@", [NSBundle mainBundle].bundleIdentifier];
    self.containerUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:Id];
    NSLog(@"%s, url:%@", __func__, containerUrl);
    return  containerUrl != nil;
}

- (NSURL*)newImageUrl
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *imgUrl = nil;
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy.MM";
    NSString *yearMonth = [fmt stringFromDate:date];
    fmt.dateFormat = @"d";
    NSString *day = [fmt stringFromDate:date];
    NSURL *dirUrl = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:@"Documents", yearMonth, day, nil]];
    NSError *error;
    BOOL result = [fm createDirectoryAtURL:dirUrl withIntermediateDirectories:YES attributes:nil error:&error];
    fmt.dateFormat = @"yyyyMMddHHmmSS";
    NSString *name = [fmt stringFromDate:date];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.png", day, name];
    NSArray *components = [NSArray arrayWithObjects:@"Documents", yearMonth, day, fileName, nil];
    imgUrl = [NSURL fileURLWithPathComponents:components];
    NSLog(@"%s, new imgage url:%@", __func__, imgUrl);
    [fmt release];
    return imgUrl;
}

- (void)movePhotoToICloud:(NSString *)photoPath
{
    NSString *prefix = [NSString stringWithFormat:@"%@/", NSHomeDirectory()];
    NSString *suffix = [photoPath substringFromIndex:prefix.length];
    NSRange range = [suffix rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *destDirSuffix = [suffix substringToIndex:range.location];
    NSMutableArray *suffixComponents = [NSMutableArray arrayWithArray:[suffix componentsSeparatedByString:@"/"]];
    [suffixComponents removeLastObject];
    NSURL *destDirUrl = [containerUrl URLByAppendingPathComponent:destDirSuffix];
    NSError *err = nil;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtURL:destDirUrl withIntermediateDirectories:YES attributes:nil error:&err];
    NSLog(@"%s, err:%@", __func__, err);
    NSString *destPath = [NSString stringWithFormat:@"%@%@",containerUrl.absoluteString, suffix];
    NSURL *destUrl = [NSURL URLWithString:destPath];
    BOOL bExist = [[NSFileManager defaultManager] isUbiquitousItemAtURL:destUrl];
    if( !bExist )
    {
        NSURL *srcUrl = [NSURL fileURLWithPath:photoPath isDirectory:NO];
        NSError *error = [[NSError alloc] init];
        myDocument *doc = [[myDocument alloc] initWithFileURL:srcUrl];
        doc.data = [NSData dataWithContentsOfFile:photoPath];
        NSFileCoordinator *fc = [[NSFileCoordinator alloc] initWithFilePresenter:doc];
        [fc coordinateWritingItemAtURL:srcUrl options:NSFileCoordinatorWritingForMoving writingItemAtURL:destUrl options:NSFileCoordinatorWritingForReplacing error:&error byAccessor:^(NSURL *fileURL, NSURL *destURL){
            NSError *e;
            BOOL r = [[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:fileURL destinationURL:destUrl error:&e];
            if (r) {
                [fc itemAtURL:fileURL didMoveToURL:destUrl];
                [doc updateChangeCount:UIDocumentChangeDone];
            }
            [fc release];
        }];
    }
}

- (id)metadataQuery:(NSMetadataQuery *)query replacementObjectForResultObject:(NSMetadataItem *)result
{
    NSLog(@"%s", __func__);
    return result;
}

- (id)metadataQuery:(NSMetadataQuery *)query replacementValueForAttribute:(NSString *)attrName value:(id)attrValue
{
    NSLog(@"%s", __func__);
    return attrValue;
}

- (void)onGatheringFinished:(NSNotification*)notification
{
    NSArray *result = query.results;
    for( NSMetadataItem *item in result )
    {
        NSURL * fileURL = [item valueForAttribute:NSMetadataItemURLKey];
        for( NSDictionary *attr in item.attributes )
        {
            NSLog(@"%@", attr);
        }
    }
    [query stopQuery];
    NSLog(@"%s,%@", __func__, notification);
}

- (void)onGatheringDidStart:(NSNotification*)notification
{
    NSLog(@"%s,%@", __func__, notification);
}

- (void)onQueryDidUpdate:(NSNotification*)notification
{
    NSLog(@"%s,%@", __func__, notification);
}

- (void)onGatheringProgress:(NSNotification*)notification
{
    NSLog(@"%s,%@", __func__, notification);
}

@end
