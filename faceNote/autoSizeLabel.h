//
//  autoSizeLabel.h
//  MOA
//
//  Created by cdc on 13-11-16.
//
//

#import <UIKit/UIKit.h>

@interface autoSizeLabel : UILabel

@property CGFloat height;

@property CGFloat width;

- (id)initWithFrame:(CGRect)frame font:(UIFont*)font text:(NSString*)text;

+ (CGSize)sizeWithWidth:(CGFloat)w Font:(UIFont*)font text:(NSString*)text;

@end
