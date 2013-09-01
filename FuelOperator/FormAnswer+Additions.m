//
//  FormAnswer+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 8/28/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "FormAnswer+Additions.h"

@implementation FormAnswer (Additions)

- (BOOL)isAnswered
{
    if([self.answer integerValue] == 0)
        return NO;
    if([self.answer integerValue] == 1)
        return YES;
    
    if(self.comment && ![self.comment isEqualToString:@""])
        return YES;
    else
        return NO;
}

@end
