//
//  FormQuestion+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 11/23/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "FormQuestion+Additions.h"

@implementation FormQuestion (Additions)

+ (FormQuestion *)updateOrCreateFromDictionary:(NSDictionary *)dict andInspection:(Inspection *)inspection
{
    NSNumber *questionID = [dict numberForKey:@"QuestionID"];
    FormQuestion *question = [FormQuestion MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"questionID == %d", [questionID integerValue]]];
    if(!question)
    {
        question = [FormQuestion MR_createEntity];
        question.inspection = inspection;
    }
    
    [question updateFromDictionary:dict];
    return question;
}

- (void)updateFromDictionary:(NSDictionary *)dict
{
    self.questionID = [dict numberForKey:@"QuestionID"];
    self.groupID = [dict numberForKey:@"GroupID"];
    self.mainCategory = [dict stringForKey:@"MainCategory"];
    self.subCategory = [dict stringForKey:@"SubCategory"];
    self.question = [dict stringForKey:@"Question"];
    self.forceComment = [dict numberForKey:@"ForceComment"];
    self.answerRequired = [dict numberForKey:@"AnswerRequired"];
    self.imageRequired = [dict numberForKey:@"ImageRequired"];
}

@end
