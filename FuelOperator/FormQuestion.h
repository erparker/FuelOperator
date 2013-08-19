//
//  FormQuestion.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/18/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Form, FormAnswer;

@interface FormQuestion : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * questionID;
@property (nonatomic, retain) Form *form;
@property (nonatomic, retain) NSSet *formAnswers;
@end

@interface FormQuestion (CoreDataGeneratedAccessors)

- (void)addFormAnswersObject:(FormAnswer *)value;
- (void)removeFormAnswersObject:(FormAnswer *)value;
- (void)addFormAnswers:(NSSet *)values;
- (void)removeFormAnswers:(NSSet *)values;

@end
