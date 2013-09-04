//
//  OnlineService.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/17/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Inspection.h"

@interface OnlineService : NSObject

+(OnlineService *)sharedService;

- (void)attemptLogin:(NSString *)username password:(NSString *)password;

@property (nonatomic, strong, readonly) NSString *sessionGuid;

- (void)updateInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo;

- (void)getAnswersForInspection:(Inspection *)inspection;

- (void)sendInspection:(Inspection *)inspection;

@end
