//
//  NSDictionary+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (NSNumber *)numberForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if(value && (value != [NSNull null]))
        return (NSNumber *)value;
    
    return [NSNumber numberWithInt:0];
}

- (NSString *)stringForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if(value && (value != [NSNull null]))
        return (NSString *)value;

    return @"";
}

@end
