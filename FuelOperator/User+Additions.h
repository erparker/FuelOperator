//
//  User+Additions.h
//  FuelOperator
//
//  Created by Gary Robinson on 10/30/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "User.h"

@interface User (Additions)

+ (User *)loggedInUser;
+ (void)login:(User *)user;
+ (void)logout;

@end
