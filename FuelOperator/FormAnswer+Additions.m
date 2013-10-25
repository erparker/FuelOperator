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
    if([self.answer integerValue] == kUnanswered)
        return NO;
    if([self.answer integerValue] == kYES)
        return YES;
    
    if(self.photos.count > 0/* self.comment && ![self.comment isEqualToString:@""]*/)
        return YES;
    else
        return NO;
}

@end
