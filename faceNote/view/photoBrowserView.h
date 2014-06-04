//
//  photoBrowserView.h
//  OA
//
//  Created by 林景隆 on 6/4/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "pageMgrView.h"
#import "photoGroupInfoObj.h"

@interface photoBrowserView : pageMgrView

- (id)initWithFrame:(CGRect)frame photoGroup:(photoGroupInfoObj*)group defaultIndex:(NSInteger)index delegate:(id)dele;

@end
