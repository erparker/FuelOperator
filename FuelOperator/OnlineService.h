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

@property (nonatomic, strong, readonly) NSString *sessionGuid;
@property (nonatomic, strong) NSString *token;

- (void)attemptLogin:(NSString *)username password:(NSString *)password;
- (void)updateFacilities;
- (void)updateInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo;
- (void)getQuestionsForInspection:(Inspection *)inspection;



- (void)sendInspection:(Inspection *)inspection;

@end
