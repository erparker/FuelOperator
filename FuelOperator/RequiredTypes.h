//
//  RequiredTypes.h
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RequiredTypes : NSManagedObject

@property (nonatomic, retain) NSNumber * requiredTypeID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;

@end
