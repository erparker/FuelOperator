//
//  UIFont+Additions.h
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Additions)

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize;
+ (UIFont *)regularFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize;

+ (UIFont *)mediumFontOfSize:(CGFloat)fontSize;
+ (UIFont *)thinFontOfSize:(CGFloat)fontSize;
+ (UIFont *)heavyFontOfSize:(CGFloat)fontSize;

+ (UIFont *)accessoryFontOfSize:(CGFloat)fontSize;

@end
