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
//    [self initCoreData];
    
    
    [self applyStyle];
    [self setupLoginScreen];
    
    //[self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupLoginScreen
{
    LoginViewController *loginController = [[LoginViewController alloc] init];
	self.window.rootViewController = loginController;
    self.window.tintColor = [UIColor whiteColor];
	
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
    
//    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
//    UIImage *image = [UIImage imageNamed:@"btn-back"];
//    UIImage *image = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)];
//    [barButtonItem setBackButtonBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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

//- (void)initCoreData
//{
//    //populate the database with default testing data
//    NSString* resourcesRoot = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/"];
//    NSString *plistFile = [resourcesRoot stringByAppendingString:@"DefaultData.plist"];
//    NSDictionary* plistDict = [[NSDictionary alloc] initWithContentsOfFile:plistFile];
//    
//    //make the stations
//    NSArray *stations = [plistDict objectForKey:@"Stations"];
//    for(NSUInteger i=0; i<stations.count; i++)
//    {
//        NSDictionary *stationDict = [stations objectAtIndex:i];
//        NSDictionary *locationDict = [stationDict objectForKey:@"location"];
//        Station *station = [Station MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"companyName = %@ AND location.streetAddress = %@", [stationDict objectForKey:@"companyName"], [locationDict objectForKey:@"streetAddress"]]];
//        if(!station)
//        {
//            station = [Station MR_createEntity];
//            station.companyName = [stationDict objectForKey:@"companyName"];
//            
//            Location *stationLocation = [Location MR_createEntity];
//            stationLocation.city = [locationDict objectForKey:@"city"];
//            stationLocation.lattitude = [locationDict objectForKey:@"lattitude"];
//            stationLocation.longitude = [locationDict objectForKey:@"longitude"];
//            stationLocation.state = [locationDict objectForKey:@"state"];
//            stationLocation.stateShort = [locationDict objectForKey:@"stateShort"];
//            stationLocation.streetAddress = [locationDict objectForKey:@"streetAddress"];
//            stationLocation.zipCode = [locationDict objectForKey:@"zipCode"];
//            
//            station.location = stationLocation;
//        }
//    }
//    
//    //make the forms
//    NSArray *forms = [plistDict objectForKey:@"Forms"];
//    for(NSUInteger i=0; i<forms.count; i++)
//    {
//        NSDictionary *formDict = [forms objectAtIndex:i];
//        Form *form = [Form MR_findFirstByAttribute:@"name" withValue:[formDict objectForKey:@"name"]];
//        if(!form)
//        {
//            form = [Form MR_createEntity];
//            form.name = [formDict objectForKey:@"name"];
//            
//            NSArray *facilityQuestions = [formDict objectForKey:@"Facility"];
//            for(NSUInteger j=0; j<facilityQuestions.count; j++)
//            {
//                FormQuestion *formQuestion = [FormQuestion MR_createEntity];
//                formQuestion.question = [facilityQuestions objectAtIndex:j];
//                formQuestion.category = @"Category 1";
//                formQuestion.type = @"Facility";
//                formQuestion.sortOrder = [NSNumber numberWithInt:j];
//                
//                [form addFormQuestionsObject:formQuestion];
//            }
//            
//            NSArray *tanksQuestions = [formDict objectForKey:@"Tanks"];
//            for(NSUInteger j=0; j<facilityQuestions.count; j++)
//            {
//                FormQuestion *formQuestion = [FormQuestion MR_createEntity];
//                formQuestion.question = [tanksQuestions objectAtIndex:j];
//                formQuestion.category = @"Category 1";
//                formQuestion.type = @"Tanks";
//                formQuestion.sortOrder = [NSNumber numberWithInt:j];
//                
//                [form addFormQuestionsObject:formQuestion];
//            }
//            
//            NSArray *dispensersQuestions = [formDict objectForKey:@"Dispensers"];
//            for(NSUInteger j=0; j<facilityQuestions.count; j++)
//            {
//                FormQuestion *formQuestion = [FormQuestion MR_createEntity];
//                formQuestion.question = [dispensersQuestions objectAtIndex:j];
//                formQuestion.category = @"Category 1";
//                formQuestion.type = @"Dispensers";
//                formQuestion.sortOrder = [NSNumber numberWithInt:j];
//                
//                [form addFormQuestionsObject:formQuestion];
//            }
//        }
//    }
//    
//    //make the inspections
//    [self initInspections];
//    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//}
//
//- (void)initInspections
//{
//    [Inspection MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"date < %@", [NSDate startOfTheWeekFromToday]]];
//
//    //add them per week for now
//    NSDate *startDate = [NSDate startOfNextWeekFromToday];
//    NSDate *endDate = [NSDate dateWithNumberOfDays:7 sinceDate:startDate];
//    
//    NSArray *thisWeeksInspections = [Inspection MR_findAllSortedBy:@"date" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]];
//    if(thisWeeksInspections.count == 0)
//        [self addInspectionsForWeekFromDate:[NSDate startOfTheWeekFromToday]];
//    
//    startDate = [NSDate startOfNextWeekFromToday];
//    endDate = [NSDate dateWithNumberOfDays:7 sinceDate:startDate];
//    
//    NSArray *nextWeeksInspections = [Inspection MR_findAllSortedBy:@"date" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]];
//    if(nextWeeksInspections.count == 0)
//        [self addInspectionsForWeekFromDate:[NSDate startOfNextWeekFromToday]];
//}
//
//- (void)addInspectionsForWeekFromDate:(NSDate *)date
//{
//    NSArray *stations = [Station MR_findAll];
//    Form *form = [Form MR_findFirst];
//    
//    NSDate *monday = [NSDate dateWithNumberOfDays:1 sinceDate:date];
//    for(NSUInteger i=0; i<stations.count; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = monday;
//        inspection.station = [stations objectAtIndex:i];
//        inspection.form = form;
//    }
//    
//    NSDate *tuesday = [NSDate dateWithNumberOfDays:2 sinceDate:date];
//    for(NSUInteger i=0; i<6; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = tuesday;
//        inspection.station = [stations objectAtIndex:i];
//        inspection.form = form;
//    }
//    
//    NSDate *wednesday = [NSDate dateWithNumberOfDays:3 sinceDate:date];
//    for(NSUInteger i=0; i<7; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = wednesday;
//        inspection.station = [stations objectAtIndex:i];
//        inspection.form = form;
//    }
//    
//    NSDate *thursday = [NSDate dateWithNumberOfDays:4 sinceDate:date];
//    for(NSUInteger i=0; i<7; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = thursday;
//        inspection.station = [stations objectAtIndex:i];
//        inspection.form = form;
//    }
//    
//    NSDate *friday = [NSDate dateWithNumberOfDays:5 sinceDate:date];
//    for(NSUInteger i=0; i<4; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = friday;
//        inspection.station = [stations objectAtIndex:i];
//        inspection.form = form;
//    }
//}


@end
