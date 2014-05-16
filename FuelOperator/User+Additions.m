//
//  User+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 10/30/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "User+Additions.h"

static User *currentUser = nil;

@implementation User (Additions)


+ (User *)loggedInUser
{
    return currentUser;
}
+ (void)login:(User *)user
{
    currentUser = user;
    
    [[NSUserDefaults standardUserDefaults] setObject:user.login forKey:@"previousLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)logout
{
    currentUser = nil;
}

@end
