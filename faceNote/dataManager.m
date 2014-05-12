//
//  dataManager.m
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import "dataManager.h"
#import <CoreData/CoreData.h>
#import <ImageIO/ImageIO.h>

dataManager *g_dataMgr;

@interface dataManager()
{
    NSManagedObjectContext *context;
}
@end

@implementation dataManager

+ (dataManager*)defaultMgr
{
    if( !g_dataMgr )
    {
        g_dataMgr = [[dataManager alloc] init];
    }
    return g_dataMgr;
}

+ (void)destroy
{
    [g_dataMgr release];
    g_dataMgr = nil;
}

- (id)init
{
    self = [super init];
    if( self )
    {
        NSString *modulePath = [NSString stringWithFormat:@"%@/Model.momd/Model.mom", [NSBundle mainBundle].bundlePath];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:modulePath];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        [url release];
        
        NSString *dbPath = [NSString stringWithFormat:@"%@/Documents/photo.db", NSHomeDirectory()];
        NSURL *dbUrl = [[NSURL alloc] initFileURLWithPath:dbPath];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *err;
        NSPersistentStore *ps = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbUrl options:nil error:&err];
        if( ps )
        {
            context = [[NSManagedObjectContext alloc] init];
            [context setPersistentStoreCoordinator:psc];
        }
        
        [dbUrl release];
        [model release];
        [psc release];
    }
    return self;
}

- (void)dealloc
{
    [context release];
    [super dealloc];
}

- (PhotoInfo*)queryPhotoInfoByPath:(NSString *)path
{
    PhotoInfo *info = nil;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PhotoInfo" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@", path];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entityDesc;
    request.predicate = predicate;
    NSError *err;
    NSArray *result = [context executeFetchRequest:request error:&err];
    if( result && result.count > 0 )
    {
        info = [result objectAtIndex:0];
    }
    [request release];
    return info;
}

- (void)addPhotoInfo:(PhotoInfo *)info
{
    ;
}

- (void)insertPhotoInfoInBlock:(void (^)(PhotoInfo *))block
{
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoInfo" inManagedObjectContext:context];
    PhotoInfo *info = (PhotoInfo*)entity;
    block(info);
    NSError *err;
    [context save:&err];
}

- (void)deletePhotoInfoByPath:(NSString *)path
{
    ;
}

- (void)deletePhotoInfo:(PhotoInfo *)info
{
    [context deleteObject:(NSManagedObject*)info];
    NSError *err;
    [context save:&err];
}

- (void)updatePhotoInfo:(PhotoInfo *)info
{
    NSError *err;
    [context save:&err];
}


@end
