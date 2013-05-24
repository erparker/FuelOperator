//
//  Station.h
//  FuelOperator
//
//  Created by Gary Robinson on 5/24/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inspection, Location;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *inspections;
@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addInspectionsObject:(Inspection *)value;
- (void)removeInspectionsObject:(Inspection *)value;
- (void)addInspections:(NSSet *)values;
- (void)removeInspections:(NSSet *)values;

@end