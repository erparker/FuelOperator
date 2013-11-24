//
//  FormQuestion.h
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormAnswer, Inspection;

@interface FormQuestion : NSManagedObject

@property (nonatomic, retain) NSString * mainCategory;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * questionID;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSString * subCategory;
@property (nonatomic, retain) NSNumber * forceComment;
@property (nonatomic, retain) NSNumber * answerRequired;
@property (nonatomic, retain) NSNumber * imageRequired;
@property (nonatomic, retain) NSSet *formAnswers;
@property (nonatomic, retain) Inspection *inspection;
@end

@interface FormQuestion (CoreDataGeneratedAccessors)

- (void)addFormAnswersObject:(FormAnswer *)value;
- (void)removeFormAnswersObject:(FormAnswer *)value;
- (void)addFormAnswers:(NSSet *)values;
- (void)removeFormAnswers:(NSSet *)values;

@end
