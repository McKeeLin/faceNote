//
//  photoView.h
//  OA
//
//  Created by 林景隆 on 5/14/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoScaleView : UIScrollView

@property (retain) NSString *photoPath;

- (id)initWithFrame:(CGRect)frame photoPath:(NSString*)path;

@end
