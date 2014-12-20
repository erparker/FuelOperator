//
//  Facility.h
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inspection;

@interface Facility : NSManagedObject

@property (nonatomic, retain) NSNumber * facilityID;
@property (nonatomic, retain) NSString * storeCode;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *inspections;
@end

@interface Facility (CoreDataGeneratedAccessors)

- (void)addInspectionsObject:(Inspection *)value;
- (void)removeInspectionsObject:(Inspection *)value;
- (void)addInspections:(NSSet *)values;
- (void)removeInspections:(NSSet *)values;

@end