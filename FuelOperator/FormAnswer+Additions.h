//
//  FormAnswer+Additions.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/28/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "FormAnswer.h"

typedef enum AnswerType : NSUInteger {
    kUnanswered,
    kYES,
    kNO
} AnswerType;

@interface FormAnswer (Additions)

- (BOOL)isAnswered;

@end
