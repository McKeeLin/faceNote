//
//  titleValueView.h
//  MOA
//
//  Created by cdc on 13-10-28.
//
//

#import <UIKit/UIKit.h>

#define TITLE_VALUE_VIEW_DEFAULT_HEIGHT 23  

@interface titleValueView : UIView

@property CGFloat height;

@property CGFloat width;



- (id)initWithFrame:(CGRect)frame title:(NSString*)title Value:(NSString*)value;

+ (CGSize)heightWithWidth:(CGFloat)width Title:(NSString*)title Value:(NSString*)value;

@end
