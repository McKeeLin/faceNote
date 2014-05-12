//
//  photoMetaDataMgr.m
//  faceNote
//
//  Created by 林景隆 on 5/12/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "photoMetaDataMgr.h"
#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>

@implementation photoMetaDataMgr

+ (void)updatePropertiesOfPhoto:(photoMetaDataObj *)metaData
{
    if( !metaData.path )
    {
        return;
    }
    
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
}

@end
