//
//  Location.h
//  FuelOperator
//
//  Created by Gary Robinson on 5/24/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) Station *station;

@end
