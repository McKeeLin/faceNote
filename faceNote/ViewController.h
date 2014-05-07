//
//  ViewController.h
//  faceNote
//
//  Created by cdc on 13-11-3.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class album;
@class albumView;

@interface ViewController : UIViewController

+ (ViewController*)defaultVC;

+ (void)destroy;

- (void)showListFromCameraView;

- (void)showListFromPhotoView;

- (void)showCameraFromListView;

- (void)showCameraFromPhotoView;

- (void)showPhotoFromListViewWithPaths:(NSArray*)photoPaths defaultIndex:(NSInteger)index albumView:(albumView*)av;

- (void)showPhotoFromTagEditView;

- (void)showMenu;

- (void)showTagEditView;

- (void)dismissCameraView;

@end
