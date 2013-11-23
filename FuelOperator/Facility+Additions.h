//
//  Facility+Additions.h
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "Facility.h"

@interface Facility (Additions)

+ (Facility *)updateOrCreateFromDictionary:(NSDictionary *)dict;
- (void)updateFromDictionary:(NSDictionary *)dict;

@end
