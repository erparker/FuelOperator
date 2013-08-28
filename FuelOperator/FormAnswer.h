//
//  FormAnswer.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/20/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormQuestion, Photo;

@interface FormAnswer : NSManagedObject

@property (nonatomic, retain) NSNumber * affirmitive;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) FormQuestion *formQuestion;
@property (nonatomic, retain) NSSet *photos;
@end

@interface FormAnswer (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
