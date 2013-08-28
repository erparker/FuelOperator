//
//  OnlineService.m
//  FuelOperator
//
//  Created by Gary Robinson on 8/17/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "OnlineService.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kBaseURLString = @"http://54.215.179.28/FOService/RestService.svc/";
static NSString * const kUsername = @"jinspector";
static NSString * const kPassword = @"Testing";
static NSString * const kEncryptNumber = @"2";

@interface OnlineService ()

@property (nonatomic, strong) AFHTTPClient *httpClient;

@property (nonatomic, strong) NSString *encryptedUserName;
@property (nonatomic, strong) NSString *encryptedPassword;

@end

@implementation OnlineService

static OnlineService *sharedOnlineService = nil;

+(OnlineService *)sharedService
{
    if(sharedOnlineService == nil)
    {
        sharedOnlineService = [[super allocWithZone:nil] init];
    }
    return sharedOnlineService;
}


- (void)attemptLogin:(NSString *)username password:(NSString *)password
{
    self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLString]];
    [self.httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    self.encryptedUserName = nil;
    self.encryptedPassword = nil;
    
    NSString *path = [NSString stringWithFormat:@"encrypt/%@/%@", username, kEncryptNumber];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.encryptedUserName = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
         [self authenticate];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self loginDone:NO];
     }
     ];
    
    
    path = [NSString stringWithFormat:@"encrypt/%@/%@", password, kEncryptNumber];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.encryptedPassword = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
         [self authenticate];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self loginDone:NO];
     }
     ];
    
}

- (void)authenticate
{
    if(self.encryptedPassword && self.encryptedUserName)
    {
    
        NSString *path = [NSString stringWithFormat:@"auth/%@/%@/%@", self.encryptedUserName, self.encryptedPassword, kEncryptNumber];
        [self.httpClient getPath:path parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             _sessionGuid = [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
             [self loginDone:YES];
         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [self loginDone:NO];
         }
         ];
        
    }
}

- (void)loginDone:(BOOL)success
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:success] forKey:@"Success"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginDone" object:nil userInfo:userInfo];
}

- (void)updateInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo
{
    [self addQuestionsFromDate:dateFrom toDate:dateTo];
}

- (void)addQuestionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo
{
    //?? should I use the current location of the phone?
    NSString *path = [NSString stringWithFormat:@"Questions/%@/%@", self.sessionGuid, @"UT"];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         for(NSDictionary *dict in results)
         {
             NSNumber *questionID = [dict objectForKey:@"QuestionID"];
             FormQuestion *question = [FormQuestion MR_findFirstByAttribute:@"questionID" withValue:questionID];
             if(!question)
             {
                 question = [FormQuestion MR_createEntity];
                 question.questionID = [dict objectForKey:@"QuestionID"];
                 question.question = [dict objectForKey:@"Question"];
                 question.category = [dict objectForKey:@"CategoryDescription"];
                 question.sortOrder = [dict objectForKey:@"SortOrder"];
                 question.type = [dict objectForKey:@"CategoryDescription"];
             }
         }
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         
         [self getScheduledInspectionsFromDate:dateFrom toDate:dateTo];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }
     ];
}

- (void)getScheduledInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSString *stringFrom = [formatter stringFromDate:dateFrom];
    NSString *stringTo = [formatter stringFromDate:dateTo];
    
    NSString *path = [NSString stringWithFormat:@"schedule/%@/%@/%@", self.sessionGuid, stringFrom, stringTo];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         [self addInspections:results];
         [self addQuestionsByScheduleFromDate:dateFrom toDate:dateTo];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }
     ];
}

- (void)addInspections:(NSArray *)inspectionData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    for(NSDictionary *dict in inspectionData)
    {
        NSNumber *inspectionID = [dict objectForKey:@"InspectionID"];
        Inspection *inspection = [Inspection MR_findFirstByAttribute:@"inspectionID" withValue:inspectionID];
        if(!inspection)
        {
            NSString *dateString = [dict objectForKey:@"InspectionDate"];
            NSDate *date = [NSDate getDateFromJSON:dateString];
            NSLog(@"inspectionDate: %@", [formatter stringFromDate:date]);
            inspection = [Inspection MR_createEntity];
            inspection.date = date;
            inspection.inspectionID = [dict objectForKey:@"InspectionID"];
            
            NSString *companyName = [dict objectForKey:@"CompanyName"];
            Station *station = [Station MR_createEntity];
            station.companyName = companyName;
            station.storeID = [dict objectForKey:@"StoreID"];
            inspection.station = station;
            
            Location *location = [Location MR_createEntity];
            location.streetAddress = [dict objectForKey:@"Address1"];
            NSString *address2 = [dict objectForKey:@"Address2"];
            if(address2 && (address2 != [NSNull null]))
                location.address2 = address2;
            location.city = [dict objectForKey:@"City"];
            location.zipCode = [dict objectForKey:@"ZipCode"];
            location.state = [dict objectForKey:@"StateID"];
            location.lattitude = [NSNumber numberWithFloat:[[dict objectForKey:@"Latitude"] floatValue]];
            location.longitude = [NSNumber numberWithFloat:[[dict objectForKey:@"Longitude"] floatValue]];
            location.station = station;
        }
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)addQuestionsByScheduleFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSString *stringFrom = [formatter stringFromDate:dateFrom];
    NSString *stringTo = [formatter stringFromDate:dateTo];
    
    NSString *path = [NSString stringWithFormat:@"questionsbyschedule/%@/%@/%@/%@", self.sessionGuid, @"UT", stringFrom, stringTo];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         //?? results has a list of questionIds and InspectionIds
         //?? use these to make the relationships
         
         for(NSDictionary *dict in results)
         {
             NSNumber *insepctionID = [dict objectForKey:@"InspectionID"];
             NSNumber *questionID = [dict objectForKey:@"QuestionID"];
             
             Inspection *inspection = [Inspection MR_findFirstByAttribute:@"inspectionID" withValue:insepctionID];
             FormQuestion *question = [FormQuestion MR_findFirstByAttribute:@"questionID" withValue:questionID];
             if(inspection && question)
                 question.inspection = inspection;
         }
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectionsUpdated" object:nil];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }
     ];
}






@end
