//
//  Inspection.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/28/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormAnswer, FormQuestion, Station;

@interface Inspection : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * inspectionID;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSSet *formQuestions;
@property (nonatomic, retain) Station *station;
@property (nonatomic, retain) NSSet *formAnswers;
@end

@interface Inspection (CoreDataGeneratedAccessors)

- (void)addFormQuestionsObject:(FormQuestion *)value;
- (void)removeFormQuestionsObject:(FormQuestion *)value;
- (void)addFormQuestions:(NSSet *)values;
- (void)removeFormQuestions:(NSSet *)values;

- (void)addFormAnswersObject:(FormAnswer *)value;
- (void)removeFormAnswersObject:(FormAnswer *)value;
- (void)addFormAnswers:(NSSet *)values;
- (void)removeFormAnswers:(NSSet *)values;

@end
