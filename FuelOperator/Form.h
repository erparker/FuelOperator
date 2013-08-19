//
//  Form.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/17/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormQuestion, Inspection;

@interface Form : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *formQuestions;
@property (nonatomic, retain) Inspection *inspection;
@end

@interface Form (CoreDataGeneratedAccessors)

- (void)addFormQuestionsObject:(FormQuestion *)value;
- (void)removeFormQuestionsObject:(FormQuestion *)value;
- (void)addFormQuestions:(NSSet *)values;
- (void)removeFormQuestions:(NSSet *)values;

@end
