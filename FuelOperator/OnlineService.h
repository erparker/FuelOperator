//
//  OnlineService.h
//  FuelOperator
//
//  Created by Gary Robinson on 8/17/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineService : NSObject

+(OnlineService *)sharedService;

- (void)attemptLogin:(NSString *)username password:(NSString *)password;

@property (nonatomic, strong, readonly) NSString *sessionGuid;

- (void)updateInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo;


@end
