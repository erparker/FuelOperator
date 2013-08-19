//
//  Inspection.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/17/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Form, FormAnswer, Station;

@interface Inspection : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * inspectionID;
@property (nonatomic, retain) Form *form;
@property (nonatomic, retain) NSSet *formAnswers;
@property (nonatomic, retain) Station *station;
@end

@interface Inspection (CoreDataGeneratedAccessors)

- (void)addFormAnswersObject:(FormAnswer *)value;
- (void)removeFormAnswersObject:(FormAnswer *)value;
- (void)addFormAnswers:(NSSet *)values;
- (void)removeFormAnswers:(NSSet *)values;

@end
