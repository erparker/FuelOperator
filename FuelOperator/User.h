//
//  User.h
//  FuelOperator
//
//  Created by Gary Robinson on 10/30/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inspection;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSData * password;
@property (nonatomic, retain) NSSet *inspections;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addInspectionsObject:(Inspection *)value;
- (void)removeInspectionsObject:(Inspection *)value;
- (void)addInspections:(NSSet *)values;
- (void)removeInspections:(NSSet *)values;

@end
