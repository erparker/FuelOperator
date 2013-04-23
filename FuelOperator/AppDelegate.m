//
//  AppDelegate.m
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "AppDelegate.h"

#import "IIViewDeckController.h"
#import "SettingsViewController.h"
#import "UpcomingInspectionsViewController.h"
#import "LoginViewController.h"
#import "TestFlight.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"43e79f16-8771-4aaf-8797-fb338175a70d"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self applyStyle];
    
    [self setupLoginScreen];
    
    
    //[self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupLoginScreen
{
    LoginViewController *loginController = [[LoginViewController alloc] init];
	self.window.rootViewController = loginController;
	
	[self.window makeKeyAndVisible];
}

- (void)loginCompleted:(id)sender
{
    UpcomingInspectionsViewController *upcomingInspectionsVC = [[UpcomingInspectionsViewController alloc] init];
    UINavigationController *inspectionsNC = [[UINavigationController alloc] initWithRootViewController:upcomingInspectionsVC];
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:inspectionsNC
                                                                                    leftViewController:settingsVC
                                                                                   rightViewController:nil];
    
    upcomingInspectionsVC.viewDeckController = deckController;
    
    //self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = deckController;
}

- (void)logout:(id)sender
{
    [self setupLoginScreen];
}

- (void)applyStyle
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
	[navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor fopDarkGreyColor]] forBarMetrics:UIBarMetricsDefault];
	[navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
										   [UIFont regularFontOfSize:6.0f], UITextAttributeFont,
										   [UIColor clearColor], UITextAttributeTextShadowColor,
										   [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
										   [UIColor whiteColor], UITextAttributeTextColor,
										   nil]];
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    UIImage *backImage = [UIImage imageNamed:@"btn-back"];
    UIImage *image = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)];
    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
