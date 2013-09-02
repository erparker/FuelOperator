//
//  Photo.h
//  FuelOperator
//
//  Created by Gary Robinson on 9/2/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FormAnswer;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSData * jpgData;
@property (nonatomic, retain) FormAnswer *formAnswer;

@end
