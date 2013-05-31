//
//  AppDelegate.m
//  FuelOperator
//
//  Created by Gary Robinson on 2/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TestFlight.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"43e79f16-8771-4aaf-8797-fb338175a70d"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"FuelOperator.sqllite"];
    [self initCoreData];
    
    
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
    self.window.rootViewController = self.rootViewController;
}

- (void)logout:(id)sender
{
    [self setupLoginScreen];
}

-(RootContainerViewController *)rootViewController
{
    if(_rootViewController == nil)
    {
        _rootViewController = [[RootContainerViewController alloc] init];
    }
    return _rootViewController;
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
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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
    [MagicalRecord cleanUp];
}

- (void)initCoreData
{
    //?? populate the database with default testing data
    NSString* resourcesRoot = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/"];
    NSString *plistFile = [resourcesRoot stringByAppendingString:@"DefaultData.plist"];
    NSDictionary* plistDict = [[NSDictionary alloc] initWithContentsOfFile:plistFile];
    
    //make the stations
    NSArray *stations = [plistDict objectForKey:@"Stations"];
    for(NSUInteger i=0; i<stations.count; i++)
    {
        NSDictionary *stationDict = [stations objectAtIndex:i];
        NSDictionary *locationDict = [stationDict objectForKey:@"location"];
        Station *station = [Station MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"companyName = %@ AND location.streetAddress = %@", [stationDict objectForKey:@"companyName"], [locationDict objectForKey:@"streetAddress"]]];
        if(!station)
        {
            station = [Station MR_createEntity];
            station.companyName = [stationDict objectForKey:@"companyName"];
            
            Location *stationLocation = [Location MR_createEntity];
            stationLocation.city = [locationDict objectForKey:@"city"];
            stationLocation.lattitude = [locationDict objectForKey:@"lattitude"];
            stationLocation.longitude = [locationDict objectForKey:@"longitude"];
            stationLocation.state = [locationDict objectForKey:@"state"];
            stationLocation.stateShort = [locationDict objectForKey:@"stateShort"];
            stationLocation.streetAddress = [locationDict objectForKey:@"streetAddress"];
            stationLocation.zipCode = [locationDict objectForKey:@"zipCode"];
            
            station.location = stationLocation;
        }
    }
 
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


@end
