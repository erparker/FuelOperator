//
//  Inspection+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "Inspection+Additions.h"

@implementation Inspection (Additions)

+ (Inspection *)updateOrCreateFromDictionary:(NSDictionary *)dict
{
    NSNumber *scheduleID = [dict numberForKey:@"ScheduleID"];
    Inspection *inspection = [Inspection MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"scheduleID == %d", [scheduleID integerValue]]];
    if(!inspection)
        inspection = [Inspection MR_createEntity];
    
    [inspection updateFromDictionary:dict];
    return inspection;
}

- (void)updateFromDictionary:(NSDictionary *)dict
{
    self.user = [User loggedInUser];
    
    self.scheduleID = [dict numberForKey:@"ScheduleID"];
    self.inspectionID = [dict numberForKey:@"InspectionID"];
    self.submitted = [NSNumber numberWithBool:[[dict objectForKey:@"InspectionCompleted"] boolValue]];
    
    NSNumber *facilityID = [dict numberForKey:@"FacilityID"];
    Facility *facility = [Facility MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"facilityID == %d", [facilityID integerValue]]];
    self.facility = facility;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *strDate = [dict objectForKey:@"InspectionDate"];
    self.date = [formatter dateFromString:strDate];
    
}

@end
