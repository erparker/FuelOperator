//
//  UIFont+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)lightFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"EauDouce-SansLight" size:fontSize];
}

+ (UIFont *)regularFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"EauDouce-SansRegular" size:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"EauDouce-SansBold" size:fontSize];
}

+ (UIFont *)mediumFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"EauDouce-SansMedium" size:fontSize];
}

+ (UIFont *)thinFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"EauDouce-SansThin" size:fontSize];
}

+ (UIFont *)heavyFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"EauDouce-SansHeavy" size:fontSize];
}

+ (UIFont *)accessoryFontOfSize:(CGFloat)fontSize
{
    return [self fontWithName:@"AppleGothic" size:fontSize];
}


@end
