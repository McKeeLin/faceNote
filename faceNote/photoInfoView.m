//
//  photoInfoView.m
//  faceNote
//
//  Created by cdc on 13-12-8.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "photoInfoView.h"
#import "titleValueView.h"
#import "locationMgr.h"
#import <CoreLocation/CoreLocation.h>
#import "PhotoInfo.h"

@interface photoInfoView()
{
    titleValueView *latitude;
    titleValueView *longitude;
    titleValueView *altitude;
    titleValueView *contry;
    titleValueView *administrativeArea;
    titleValueView *locality;
    titleValueView *subLocality;
    titleValueView *thoroughfare;
    titleValueView *subThoroughfare;

}

@end

@implementation photoInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame info:(PhotoInfo *)pi
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self updateInfo:pi];
    }
    return self;
}

- (void)dealloc
{
    [latitude release];
    [longitude release];
    [altitude release];
    [contry release];
    [administrativeArea release];
    [locality release];
    [subLocality release];
    [thoroughfare release];
    [subThoroughfare release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateInfo:(PhotoInfo*)pi
{
    CGRect labelFrame = CGRectMake(5, 30, 310, 18);
    if( latitude )
    {
        [latitude removeFromSuperview];
        [latitude release];
    }
    latitude = [[titleValueView alloc] initWithFrame:labelFrame title:@"纬度" Value:[NSString stringWithFormat:@"%f", pi.latitude.floatValue]];
    [self addSubview:latitude];
    labelFrame.origin.y += latitude.height;
    
    if( longitude )
    {
        [longitude removeFromSuperview];
        [longitude release];
    }
    longitude = [[titleValueView alloc] initWithFrame:labelFrame title:@"经度"
                                                Value:[NSString stringWithFormat:@"%f", pi.longitude.floatValue]];
    [self addSubview:longitude];
    labelFrame.origin.y += longitude.height;
    
    if( altitude )
    {
        [altitude removeFromSuperview];
        [altitude release];
    }
    altitude = [[titleValueView alloc] initWithFrame:labelFrame title:@"海拔"
                                               Value:[NSString stringWithFormat:@"%f", pi.altitude.floatValue]];
    [self addSubview:altitude];
    labelFrame.origin.y += altitude.height;
    
    /*
    if( contry )
    {
        [contry removeFromSuperview];
        contry = nil;
    }
    contry = [[titleValueView alloc] initWithFrame:labelFrame title:@"国家" Value:mark.country];
    [self addSubview:contry];
    labelFrame.origin.y += contry.height;
    
    if( administrativeArea )
    {
        [administrativeArea removeFromSuperview];
        administrativeArea = nil;
    }
    administrativeArea = [[titleValueView alloc] initWithFrame:labelFrame title:@"省份" Value:mark.administrativeArea];
    [self addSubview:administrativeArea];
    labelFrame.origin.y += administrativeArea.height;
    
    if( locality )
    {
        [locality removeFromSuperview];
        locality = nil;
    }
    locality = [[titleValueView alloc] initWithFrame:labelFrame title:@"市" Value:mark.locality];
    [self addSubview:locality];
    labelFrame.origin.y += locality.height;
    
    if( subLocality )
    {
        [subLocality removeFromSuperview];
        subLocality = nil;
    }
    subLocality = [[titleValueView alloc] initWithFrame:labelFrame title:@"县" Value:mark.subLocality];
    [self addSubview:subLocality];
    labelFrame.origin.y += subLocality.height;
    
    if( thoroughfare )
    {
        [thoroughfare removeFromSuperview];
        thoroughfare = nil;
    }
    thoroughfare = [[titleValueView alloc] initWithFrame:labelFrame title:@"街道" Value:mark.thoroughfare];
    [self addSubview:thoroughfare];
    labelFrame.origin.y += thoroughfare.height;
    */
    
    if( subThoroughfare )
    {
        [subThoroughfare removeFromSuperview];
        subThoroughfare = nil;
    }
    subThoroughfare = [[titleValueView alloc] initWithFrame:labelFrame title:@"地址" Value:pi.place];
    [self addSubview:subThoroughfare];
    labelFrame.origin.y += subThoroughfare.height;
}

@end
