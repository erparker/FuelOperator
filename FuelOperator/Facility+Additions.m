//
//  Facility+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "Facility+Additions.h"

@implementation Facility (Additions)

+ (Facility *)updateOrCreateFromDictionary:(NSDictionary *)dict
{
    NSNumber *facilityID = [dict numberForKey:@"FacilityID"];
    Facility *facility = [Facility MR_findFirstByAttribute:@"facilityID" withValue:[NSString stringWithFormat:@"%d", [facilityID integerValue]]];
    if(!facility)
        facility = [Facility MR_createEntity];
    
    [facility updateFromDictionary:dict];
    return facility;
}

- (void)updateFromDictionary:(NSDictionary *)dict
{
    self.facilityID = [dict numberForKey:@"FacilityID"];
    self.storeCode = [dict stringForKey:@"StoreCode"];
    self.address1 = [dict stringForKey:@"Address1"];
    self.address2 = [dict stringForKey:@"Address2"];
    self.city = [dict stringForKey:@"City"];
    self.state = [dict stringForKey:@"State"];
    self.zip = [dict stringForKey:@"Zip"];
    self.lattitude = [dict numberForKey:@"Latitude"];
    self.longitude = [dict numberForKey:@"Longitude"];
}

@end
