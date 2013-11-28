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

- (NSString *)answerText
{
    if([self.answer integerValue] == kYES)
        return @"T";
    else if([self.answer integerValue] == kUnanswered)
        return @" ";
    
    return @"F";
}

- (NSString *)commentText
{
    if(!self.comment)
        return @"";
    
    return self.comment;
}

- (void)updateFromDictionary:(NSDictionary *)dict
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *strDate = [dict objectForKey:@"LastUpdated"];
    NSDate *date = [formatter dateFromString:strDate];
    
    //check the updated date first to see if it is newer
    if(self.dateModified && ([self.dateModified compare:date] == NSOrderedDescending))
        return;
    
    self.dateModified = date;
    self.comment = [dict stringForKey:@"Comments"];
    
    NSString *answer = [dict stringForKey:@"Answer"];
    if([answer isEqualToString:@"T"])
        self.answer = [NSNumber numberWithInt:kYES];
    else if([answer isEqualToString:@"F"])
        self.answer = [NSNumber numberWithInt:kNO];
    else
        self.answer = [NSNumber numberWithInt:kUnanswered];
    
}


@end
