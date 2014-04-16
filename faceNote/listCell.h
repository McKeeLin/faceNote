//
//  listCell.h
//  faceNote
//
//  Created by cdc on 13-11-24.
//  Copyright (c) 2013年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "album.h"

@interface listCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier album:(album*)am addr:(NSString*)addr title:(NSString*)title;

- (void)setAlbum:(album*)am addr:(NSString*)addr title:(NSString*)title;

@end
