//
//  SeedDatabase.m
//  FuelOperator
//
//  Created by Gary Robinson on 10/26/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "SeedDatabase.h"

@implementation SeedDatabase

//+ (void)populate
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
////            stationLocation.stateShort = [locationDict objectForKey:@"stateShort"];
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
//    [SeedDatabase initInspections];
//
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//}
//
//+ (void)initInspections
//{
//    [Inspection MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"date < %@", [NSDate startOfTheWeekFromToday]]];
//
//    //add them per week for now
//    NSDate *startDate = [NSDate startOfNextWeekFromToday];
//    NSDate *endDate = [NSDate dateWithNumberOfDays:7 sinceDate:startDate];
//
//    NSArray *thisWeeksInspections = [Inspection MR_findAllSortedBy:@"date" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]];
//    if(thisWeeksInspections.count == 0)
//        [SeedDatabase addInspectionsForWeekFromDate:[NSDate startOfTheWeekFromToday]];
//
//    startDate = [NSDate startOfNextWeekFromToday];
//    endDate = [NSDate dateWithNumberOfDays:7 sinceDate:startDate];
//
//    NSArray *nextWeeksInspections = [Inspection MR_findAllSortedBy:@"date" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", startDate, endDate]];
//    if(nextWeeksInspections.count == 0)
//        [SeedDatabase addInspectionsForWeekFromDate:[NSDate startOfNextWeekFromToday]];
//}
//
//+ (void)addInspectionsForWeekFromDate:(NSDate *)date
//{
//    NSArray *stations = [Station MR_findAll];
////    Form *form = [Form MR_findFirst];
//
//    NSDate *monday = [NSDate dateWithNumberOfDays:1 sinceDate:date];
//    for(NSUInteger i=0; i<stations.count; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = monday;
//        inspection.station = [stations objectAtIndex:i];
////        inspection.form = form;
//    }
//
//    NSDate *tuesday = [NSDate dateWithNumberOfDays:2 sinceDate:date];
//    for(NSUInteger i=0; i<6; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = tuesday;
//        inspection.station = [stations objectAtIndex:i];
////        inspection.form = form;
//    }
//
//    NSDate *wednesday = [NSDate dateWithNumberOfDays:3 sinceDate:date];
//    for(NSUInteger i=0; i<7; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = wednesday;
//        inspection.station = [stations objectAtIndex:i];
////        inspection.form = form;
//    }
//
//    NSDate *thursday = [NSDate dateWithNumberOfDays:4 sinceDate:date];
//    for(NSUInteger i=0; i<7; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = thursday;
//        inspection.station = [stations objectAtIndex:i];
////        inspection.form = form;
//    }
//
//    NSDate *friday = [NSDate dateWithNumberOfDays:5 sinceDate:date];
//    for(NSUInteger i=0; i<4; i++)
//    {
//        Inspection *inspection = [Inspection MR_createEntity];
//        inspection.date = friday;
//        inspection.station = [stations objectAtIndex:i];
////        inspection.form = form;
//    }
//}

@end
