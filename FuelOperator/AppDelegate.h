//
//  AppDelegate.h
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)loginCompleted:(id)sender;
- (void)logout:(id)sender;
- (void)toggleLeftView:(id)sender;
- (void)settingsWillAppear:(id)sender;
- (void)settingsWillDisappear:(id)sender;

@end
