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

@interface AppDelegate ()

@property (nonatomic, strong) IIViewDeckController *deckController;
@property (nonatomic, strong) UINavigationController *inspectionsNC;
@property (nonatomic, strong) SettingsViewController *settingsVC;
@property (nonatomic, strong) UIView *blockingNavView;
@property (nonatomic, strong) UIView *blockingView;

@end

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
    self.window.rootViewController = self.deckController;
}

- (void)logout:(id)sender
{
    [self setupLoginScreen];
}

- (void)toggleLeftView:(id)sender
{
    [self.deckController toggleLeftView];
}

- (void)settingsWillAppear:(id)sender
{
    [self.inspectionsNC.navigationBar addSubview:self.blockingNavView];
    [self.inspectionsNC.visibleViewController.view addSubview:self.blockingView];
}

- (void)settingsWillDisappear:(id)sender
{
    [self.blockingNavView removeFromSuperview];
    self.blockingNavView = nil;
    [self.blockingView removeFromSuperview];
    self.blockingView = nil;
}

- (IIViewDeckController*)deckController
{
    if(_deckController == nil)
    {
        _deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.inspectionsNC leftViewController:self.settingsVC rightViewController:nil];
        [_deckController setLeftSize:66];
    }
    return _deckController;
}

- (UINavigationController*)inspectionsNC
{
    if(_inspectionsNC == nil)
    {
        UpcomingInspectionsViewController *upcomingInspectionsVC = [[UpcomingInspectionsViewController alloc] init];
        _inspectionsNC = [[UINavigationController alloc] initWithRootViewController:upcomingInspectionsVC];
    }
    return _inspectionsNC;
}

- (SettingsViewController*)settingsVC
{
    if(_settingsVC == nil)
    {
        _settingsVC = [[SettingsViewController alloc] init];
    }
    return _settingsVC;
}

- (UIView *)blockingNavView
{
    if(_blockingNavView == nil)
    {
        _blockingNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.inspectionsNC.navigationBar.frame.size.width, self.inspectionsNC.navigationBar.frame.size.height)];
        _blockingNavView.backgroundColor = [UIColor clearColor];
        _blockingNavView.userInteractionEnabled = YES;
        [_blockingNavView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockingViewTapped:)]];
    }
    return _blockingNavView;
}

- (UIView *)blockingView
{
    if(_blockingView == nil)
    {
        _blockingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.inspectionsNC.visibleViewController.view.frame.size.width, self.inspectionsNC.visibleViewController.view.frame.size.height)];
        _blockingView.backgroundColor = [UIColor clearColor];
        _blockingView.userInteractionEnabled = YES;
        [_blockingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blockingViewTapped:)]];
    }
    return _blockingView;
}

- (void)blockingViewTapped:(id)sender
{
    [self toggleLeftView:self];
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
