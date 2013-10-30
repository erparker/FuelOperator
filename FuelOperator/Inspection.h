//
//  Inspection.h
//  FuelOperator
//
//  Created by Gary Robinson on 10/29/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormAnswer, FormQuestion, Station, User;

@interface Inspection : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * inspectionID;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSSet *formAnswers;
@property (nonatomic, retain) NSSet *formQuestions;
@property (nonatomic, retain) Station *station;
@property (nonatomic, retain) User *user;
@end

@interface Inspection (CoreDataGeneratedAccessors)

- (void)addFormAnswersObject:(FormAnswer *)value;
- (void)removeFormAnswersObject:(FormAnswer *)value;
- (void)addFormAnswers:(NSSet *)values;
- (void)removeFormAnswers:(NSSet *)values;

- (void)addFormQuestionsObject:(FormQuestion *)value;
- (void)removeFormQuestionsObject:(FormQuestion *)value;
- (void)addFormQuestions:(NSSet *)values;
- (void)removeFormQuestions:(NSSet *)values;

@end
