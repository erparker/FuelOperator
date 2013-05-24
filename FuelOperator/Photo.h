//
//  Photo.h
//  FuelOperator
//
//  Created by Gary Robinson on 5/24/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormAnswer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageFile;
@property (nonatomic, retain) FormAnswer *formAnswer;

@end
