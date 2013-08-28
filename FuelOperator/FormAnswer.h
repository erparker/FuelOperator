//
//  FormAnswer.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/28/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormQuestion, Inspection, Photo;

@interface FormAnswer : NSManagedObject

@property (nonatomic, retain) NSNumber * answer;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) FormQuestion *formQuestion;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Inspection *inspection;
@end

@interface FormAnswer (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
