//
//  photoMetaDataMgr.m
//  faceNote
//
//  Created by 林景隆 on 5/12/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "photoDataMgr.h"
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import "icloudHelper.h"
#import "photoGroupInfoObj.h"

@implementation photoDataMgr

@synthesize photoGroups;

+ (photoDataMgr*)manager
{
    static photoDataMgr *s_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^(){
        s_manager = [[photoDataMgr alloc] init];
    });
    return s_manager;
}

- (id)init
{
    self = [super init];
    if( self ){
        photoGroups = [[NSMutableArray alloc] initWithCapacity:0];
        [self loadData];
    }
    return self;
}

- (void)dealloc
{
    [photoGroups release];
    [super dealloc];
}



- (void)loadData
{
    [self synchronizePhotoFromICloudContainer];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *photoDir = [[icloudHelper helper].appDocumentPath stringByAppendingPathComponent:PHOTO_DIR_NAME];
    NSArray *subPaths = [fm subpathsAtPath:photoDir];
    for( NSString *subPath in subPaths ){
        NSRange r = [subPath rangeOfString:PHOTO_FILE_TYPE];
        if( r.location != NSNotFound )
        {
            NSString *filePath = [photoDir stringByAppendingPathComponent:subPath];
            NSString *key = [subPath substringToIndex:r.location - 7];
            NSLog(@".....................%@",key);
            BOOL keyFound = NO;
            for( photoGroupInfoObj *info in photoGroups ){
                if( [info.key isEqualToString:key] ){
                    /*
                    for( NSString *photoPath in info.photoPaths )
                    {
                        NSRange r2 = [photoPath rangeOfString:subPath];
                        if( r2.location == NSNotFound ){
                            [info.photoPaths addObject:filePath];
                        }
                    }
                    */
                    [info.photoPaths addObject:filePath];
                    keyFound = YES;
                    break;
                }
            }
            
            if( !keyFound ){
                photoGroupInfoObj *groupInfo = [[photoGroupInfoObj alloc] init];
                groupInfo.key = key;
                [groupInfo.photoPaths addObject:filePath];
                [photoGroups addObject:groupInfo];
            }
        }
    }
}

- (photoMetaDataObj*)metaDataOfPhoto:(NSString *)path
{
    photoMetaDataObj *metaData = nil;
    NSURL *fileUrl = [NSURL fileURLWithPath:metaData.path];
    CFURLRef urlRef = (CFURLRef)fileUrl;
    CGImageSourceRef sourceRef = CGImageSourceCreateWithURL(urlRef, nil);
    NSDictionary *properties = (NSDictionary*)CGImageSourceCopyProperties(sourceRef, nil);
    NSString *strWidth = [properties objectForKey:(NSString*)kCGImagePropertyPixelWidth];
    metaData.width = strWidth.floatValue;
    NSString *strHeight = [properties objectForKey:(NSString*)kCGImagePropertyPixelHeight];
    metaData.height = strHeight.floatValue;
    NSDictionary *exifProperty = [properties objectForKey:(NSString*)kCGImagePropertyExifDictionary];
    metaData.creteTime = [exifProperty objectForKey:(NSString*)kCGImagePropertyExifDateTimeOriginal];
    NSDictionary *gpsProperty = [properties objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
    NSString *latitude = [gpsProperty objectForKey:(NSString*)kCGImagePropertyGPSLatitude];
    metaData.latitude = latitude.doubleValue;
    NSString *longitude = [gpsProperty objectForKey:(NSString*)kCGImagePropertyGPSLongitude];
    metaData.longitude = longitude.doubleValue;
    NSString *altitude = [gpsProperty objectForKey:(NSString*)kCGImagePropertyGPSAltitude];
    metaData.altitude = altitude.doubleValue;
    return metaData;
}

- (UIImage*)thumbnailImageOfFile:(NSString*)file maxPixel:(float)max
{
    NSURL *fileUrl = [NSURL fileURLWithPath:file];
    CFURLRef urlRef = (CFURLRef)fileUrl;
    CGImageSourceRef sourceRef = CGImageSourceCreateWithURL(urlRef, nil);
    CFNumberRef maxPixel = CFNumberCreate(nil, kCFNumberFloatType, &max);
    CFMutableDictionaryRef options = CFDictionaryCreateMutable(nil, 0, nil, nil);
    CFBooleanRef boolValue = kCFBooleanTrue;
    CFDictionarySetValue(options, kCGImageSourceCreateThumbnailFromImageAlways, boolValue);
    CFDictionarySetValue(options, kCGImageSourceThumbnailMaxPixelSize, maxPixel);
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, options);
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    CGImageRelease(thumbnail);
    CFRelease(sourceRef);
    return image;
}

- (void)deletePhoto:(NSString *)path
{
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&err];
    if( err )
    {
        NSLog(@"%s, delete %@ failed, error:%@", __func__, path, err.localizedDescription);
        return;
    }
    else{
        for( photoGroupInfoObj *group in photoGroups ){
            [group.photoPaths removeObject:path];
        }
    }
    
    if( [icloudHelper helper].synchronizationEnabled ){
        NSString *tempFile = [path stringByReplacingOccurrencesOfString:[icloudHelper helper].appDocumentPath withString:[icloudHelper helper].iCloudDocumentPath];
        NSString *iCloudPhotoPath = [tempFile stringByReplacingOccurrencesOfString:PHOTO_FILE_TYPE withString:ENCODED_FILE_TYPE];
        if( ![[NSFileManager defaultManager] removeItemAtPath:iCloudPhotoPath error:&err] ){
            NSLog(@"remove icloud file:%@ failed, error:%@", iCloudPhotoPath, err.description);
        }
    }
}

- (void)addPhoto:(NSData *)data
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dir = [NSString stringWithFormat:@"%@/photos", [icloudHelper helper].appDocumentPath];
    NSError *err;
    if( ![fm fileExistsAtPath:dir] )
    {
        if( ![fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err] )
        {
            if( err )
            {
                NSLog(@"%s, create path failed:%@", __func__, err);
                err = nil;
            }
        }
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmmSS";
    NSString *name = [fmt stringFromDate:date];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", dir, name, PHOTO_FILE_TYPE];
    if( ![data writeToFile:filePath options:NSDataWritingAtomic error:&err] )
    {
        NSLog(@"save photo data to %@ faile, %@", filePath, err.localizedDescription );
        return;
    }
    
    if( [icloudHelper helper].synchronizationEnabled ){
        NSString *iCloudContainerPhotoPath = [[icloudHelper helper].iCloudDocumentPath stringByAppendingPathComponent:PHOTO_DIR_NAME];
        if( [fm fileExistsAtPath:iCloudContainerPhotoPath] )
        {
            if( ![fm createDirectoryAtPath:iCloudContainerPhotoPath withIntermediateDirectories:YES attributes:nil error:&err] )
            {
                NSLog(@"create %@ failed, %@", iCloudContainerPhotoPath, err.localizedDescription);
                return;
            }
        }
        NSString *tempPath = [filePath stringByReplacingOccurrencesOfString:[icloudHelper helper].appDocumentPath withString:[icloudHelper helper].iCloudDocumentPath];
        NSString *iCloudPhotoPath = [tempPath stringByReplacingOccurrencesOfString:PHOTO_FILE_TYPE withString:ENCODED_FILE_TYPE];
        [self encodeFile:filePath to:iCloudPhotoPath];
    }
}


- (void)encodeFile:(NSString *)file to:(NSString *)destFile
{
    NSData *srcData = [NSData dataWithContentsOfFile:file];
    Byte key = 1;
    time_t t = time(NULL);
    int mod = t % 255;
    NSLog(@"HEADER %d",mod);
    Byte headerByte = mod;
    NSMutableData *destData = [[NSMutableData alloc] initWithCapacity:srcData.length+2];
    [destData appendBytes:&headerByte length:1];
    for( NSInteger i = 0; i < srcData.length; i++ ){
        Byte subByte = 0;
        NSRange r = NSMakeRange(i, 1);
        [srcData getBytes:&subByte range:r];
        if( i % 2 == 1 ){
            Byte newByte = subByte ^ key;
            [destData appendBytes:&newByte length:1];
        }
        else{
            [destData appendBytes:&subByte length:1];
        }
    }
    Byte tailerByte = time(NULL) % 10;
    [destData appendBytes:&tailerByte length:1];
    [destData writeToFile:destFile atomically:YES];
}

- (void)decodeFile:(NSString *)file to:(NSString *)destFile
{
    NSData *srcData = [NSData dataWithContentsOfFile:file];
    Byte key = 1;
    NSMutableData *destData = [[NSMutableData alloc] initWithCapacity:srcData.length-1];
    for( NSInteger i = 1; i < srcData.length - 1; i++ ){
        Byte subByte = 0;
        NSRange r = NSMakeRange(i, 1);
        [srcData getBytes:&subByte range:r];
        if( (i-1) % 2 == 1 ){
            Byte newByte = subByte ^ key;
            [destData appendBytes:&newByte length:1];
        }
        else{
            [destData appendBytes:&subByte length:1];
        }
    }
    [destData writeToFile:destFile atomically:YES];
}


- (void)synchronizePhotoFromICloudContainer
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *localPhotoDir = [[icloudHelper helper].appDocumentPath stringByAppendingString:PHOTO_DIR_NAME];
    NSString *iCloudContainerPhotoDir = [[icloudHelper helper].iCloudDocumentPath stringByAppendingString:PHOTO_DIR_NAME];
    NSArray *localPhotos = [fm subpathsAtPath:localPhotoDir];
    NSArray *iCloudContainerPhotos = [fm subpathsAtPath:iCloudContainerPhotoDir];
    for( NSString *iCloudContainerPhoto in iCloudContainerPhotos ){
        NSString *localPhoto = [iCloudContainerPhoto stringByReplacingOccurrencesOfString:ENCODED_FILE_TYPE withString:PHOTO_FILE_TYPE];
        if( ![localPhotos containsObject:localPhoto] )
        {
            if( [fm isReadableFileAtPath:localPhoto] )
            {
                [self decodeFile:iCloudContainerPhoto to:localPhoto];
            }
        }
    }
}


@end
