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

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *encryptedUserName;
@property (nonatomic, strong) NSString *encryptedPassword;

@property (nonatomic, strong) NSMutableArray *processingAnswers;
@property (nonatomic, strong) NSMutableArray *processingPhotos;

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
    
    self.userName = username;
    self.password = password;
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
             
             User *user = [User MR_findFirstByAttribute:@"login" withValue:self.userName];
             if(!user)
             {
                 user = [User MR_createEntity];
                 user.login = self.userName;
                 user.password = [NSString encrypt:self.password];
             }
             [User login:user];
             [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
             
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
    if(!success)
        [User logout];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:success] forKey:@"Success"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginDone" object:nil userInfo:userInfo];
}

- (void)updateInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo
{
    [self.httpClient setParameterEncoding:AFJSONParameterEncoding];
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
            inspection.user = [User loggedInUser];
            inspection.date = date;
            inspection.progress = [NSNumber numberWithFloat:0.0];
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
            if([dict objectForKey:@"Latitude"] && ([dict objectForKey:@"Latitude"] != [NSNull null]))
            {
                NSString *lat = [dict objectForKey:@"Latitude"];
                location.lattitude = [NSNumber numberWithFloat:[lat floatValue]];
//                location.lattitude = [NSNumber numberWithFloat:[[dict objectForKey:@"Latitude"] floatValue]];
            }
            if([dict objectForKey:@"Longitude"] && ([dict objectForKey:@"Longitude"] != [NSNull null]))
            {
                NSString *longitude = [dict objectForKey:@"Longitude"];
                location.longitude = [NSNumber numberWithFloat:[longitude  floatValue]];
            }
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
                 [question addInspectionsObject:inspection];
         }
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectionsUpdated" object:nil];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }
     ];
}

- (void)getAnswersForInspection:(Inspection *)inspection
{
    NSInteger inspectionID = [inspection.inspectionID integerValue];
    NSString *path = [NSString stringWithFormat:@"inspectionData/%@/%d", self.sessionGuid, inspectionID];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         NSLog(@"Got %d answers for inspection", results.count);
         
         for(NSDictionary *dict in results)
         {
             NSInteger questionID = [[dict objectForKey:@"QuestionID"] integerValue];
             
             NSPredicate *pred = [NSPredicate predicateWithFormat:@"(formQuestion.questionID = %d) AND (inspection.inspectionID = %d)", questionID, inspectionID];
             FormAnswer *answer = [FormAnswer MR_findFirstWithPredicate:pred];
             
             //?? make a new one if it doesn't exist yet, update the existing one otherwise
             if(!answer)
             {
                 answer = [FormAnswer MR_createEntity];
                 answer.inspection = inspection;
                 FormQuestion *question = [FormQuestion MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"questionID = %d", questionID]];
                 answer.formQuestion = question;
             }
             
             if([dict objectForKey:@"Comment"] != [NSNull null])
                 answer.comment = [dict objectForKey:@"Comment"];
             
             BOOL response = [[dict objectForKey:@"Response"] boolValue];
             if(response)
                 answer.answer = [NSNumber numberWithInt:kYES];
             else
                 answer.answer = [NSNumber numberWithInt:kNO];
             
             [self getPhotosForAnswer:answer withDictionary:dict];
         }
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"answersUpdated" object:nil];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed getAnswersForInspection");
     }
     ];
}

- (void)getPhotosForAnswer:(FormAnswer *)answer withDictionary:(NSDictionary *)dict
{
    NSArray *photos = [[answer.photos allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    Photo *photo;
    
    for(NSInteger i=0; i<3; i++)
    {
        NSString *key = [NSString stringWithFormat:@"Picture%d", i+1];
        if([dict objectForKey:key] != [NSNull null])
        {
            if(photos.count > i)
            {
                photo = [photos objectAtIndex:i];
                //?? don't re-download the photo unless it has changed
            }
            else
            {
                photo = [Photo MR_createEntity];
                photo.index = [NSNumber numberWithInt:i];
                photo.formAnswer = answer;
                [self getPhoto:photo withDictionary:dict position:i+1];
            }
        }
        else if(photos.count > i)
        {
            //remove the photo if it exists
            photo = [photos objectAtIndex:i];
            [photo MR_deleteEntity];
        }
    }
}

- (void)getPhoto:(Photo *)photo withDictionary:(NSDictionary *)dict position:(NSInteger)position
{
    NSInteger questionID = [[dict objectForKey:@"QuestionID"] integerValue];
    NSInteger inspectionID = [[dict objectForKey:@"InspectionID"] integerValue];
    
    NSString *path = [NSString stringWithFormat:@"GetImage/%@/%d/%d/%d", self.sessionGuid, inspectionID, questionID, position];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         UIImage *image = [UIImage imageWithData:(NSData *)(responseObject)];
         photo.jpgData = (NSData *)(responseObject);
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         NSLog(@"");         
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed getPhoto");
     }
     ];
}


- (void)sendInspection:(Inspection *)inspection
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"inspection.inspectionID = %d", [inspection.inspectionID integerValue]];
    self.processingAnswers = [[NSMutableArray alloc] initWithArray:[FormAnswer MR_findAllWithPredicate:pred]];
    [self processNextAnswer];
}

- (void)processNextAnswer
{
    if(self.processingAnswers.count == 0)
        return;
    
    FormAnswer *answer = [self.processingAnswers lastObject];
    
    //create JSON InspectionData object to send for this answer
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *photos = [[answer.photos allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    self.processingPhotos = [[NSMutableArray alloc] initWithArray:photos];
    
    if(([answer.answer integerValue] == kNO) && (photos.count == 0))
    {
        //?? keep track of the invalid errors
        [self.processingAnswers removeLastObject];
        [self processNextAnswer];
        return;
    }
    else if([answer.answer integerValue] == kUnanswered)
    {
        //?? keep track of the invalid errors
        [self.processingAnswers removeLastObject];
        [self processNextAnswer];
        return;
    }
    
    NSString *picture1 = nil;
    if(photos.count >= 1)
        picture1 = [NSString stringWithFormat:@"%d-1.jpg", [answer.formQuestion.questionID integerValue]];
    NSString *picture2 = nil;
    if(photos.count >= 2)
        picture2 = [NSString stringWithFormat:@"%d-2.jpg", [answer.formQuestion.questionID integerValue]];
    NSString *picture3 = nil;
    if(photos.count >= 3)
        picture3 = [NSString stringWithFormat:@"%d-3.jpg", [answer.formQuestion.questionID integerValue]];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:answer.comment forKey:@"Comment"];
    [dict setValue:answer.inspection.inspectionID forKey:@"InspectionID"];
    [dict setValue:picture1 forKey:@"Picture1"];
    [dict setValue:picture2 forKey:@"Picture2"];
    [dict setValue:picture3 forKey:@"Picture3"];
    [dict setValue:answer.formQuestion.questionID forKey:@"QuestionID"];
    [dict setValue:[NSNumber numberWithBool:([answer.answer integerValue] == kYES)] forKey:@"Response"];
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:dict];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0/*NSJSONWritingPrettyPrinted*/ error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"posting answer to question %d, params %@", [answer.formQuestion.questionID integerValue], jsonString);
    NSString *path = [NSString stringWithFormat:@"SaveInspectionData?SessionID=%@", self.sessionGuid];
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:path parameters:nil/*params*/];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"JSON Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Success Block Hit! %@", response);
        [self processNextPhoto:1];
        [self.processingAnswers removeLastObject];
        [self processNextAnswer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Failure Block Hit! %@", error.description);
         [self.processingAnswers removeLastObject];
         [self processNextAnswer];
    }];
    
    [operation start];
    
   
}

- (void)processNextPhoto:(NSInteger)position
{
    if(self.processingPhotos.count == 0)
        return;
    
    Photo *photo = [self.processingPhotos objectAtIndex:0];
    Inspection *inspection = photo.formAnswer.inspection;
    FormQuestion *question = photo.formAnswer.formQuestion;
    
    //?? need to send content type of text/plain
    NSString *path = [NSString stringWithFormat:@"SaveImage?sessionID=%@&inspectionID=%d&questionID=%d&position=%d", self.sessionGuid, [inspection.inspectionID integerValue], [question.questionID integerValue], position];
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:path parameters:nil];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:photo.jpgData];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Success Photo Block Hit! %@", response);

        [self.processingPhotos removeObjectAtIndex:0];
        [self processNextPhoto:(position+1)];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failure Photo Block Hit!, %@", error.description);

        [self.processingPhotos removeObjectAtIndex:0];
        [self processNextPhoto:(position+1)];

    }];
    
    [operation start];
    
}





@end
