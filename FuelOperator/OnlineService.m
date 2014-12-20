//
//  OnlineService.m
//  FuelOperator
//
//  Created by Gary Robinson on 8/17/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "OnlineService.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define DEFAULT_NUM_WEEKS 4

static NSString * const kBaseURLString = @"http://www.fueloperator.com/";
static NSString * const kBaseURLStringGenerationBay = @"http://www.generationbay.com/";

@interface OnlineService ()

@property (nonatomic, strong) AFHTTPClient *httpClient;

@property (nonatomic) NSInteger numProcessingInspections;
@property (nonatomic, strong) NSMutableArray *processingInspections;
@property (nonatomic, strong) NSMutableArray *processingAnswers;
@property (nonatomic, strong) NSMutableArray *processingPhotos;

@property (nonatomic, strong) Inspection *postingInspection;
@property (nonatomic) BOOL pauseSubmit;
@property (nonatomic) NSInteger postAnswerIndex;
@property (nonatomic, strong) UIImage *signatureImage;

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


- (void)attemptLogin:(NSString *)username password:(NSString *)password baseURL:(NSString *)baseURL
{
    if(baseURL == nil)
        baseURL = kBaseURLString;
    
    self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    [self.httpClient setParameterEncoding:AFFormURLParameterEncoding];
    
    NSDictionary *params = @{@"userName" : username,
                             @"password" : password,
                             @"grant_type" : @"password"};
    
    NSString *path = @"Token";
    [self.httpClient postPath:path parameters:params
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         self.token = [result objectForKey:@"access_token"];
         NSString* auth = [NSString stringWithFormat:@"Bearer %@", self.token];
         [self.httpClient setDefaultHeader:@"Authorization" value:auth];
         
         User *user = [User MR_findFirstByAttribute:@"login" withValue:username];
         if(!user)
         {
             user = [User MR_createEntity];
             user.login = username;
             user.password = [NSString encrypt:password];
         }
         [User login:user];
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [self updateFacilities];
         
         //?? also update the requiredTypes
         
     }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self loginDone:NO tryOffline:YES];
     }
     ];
    
}

- (void)attempBackgroundLogin
{
    NSString *previousLoginName = [[NSUserDefaults standardUserDefaults] objectForKey:@"previousLogin"];
    User *previousUser = [User MR_findFirstByAttribute:@"login" withValue:previousLoginName];
    if(!previousUser)
        return;
    
    NSString *decryptedPassword = [NSString decrypt:previousUser.password];
    [self attemptLogin:previousUser.login password:decryptedPassword baseURL:kBaseURLString];
}

- (void)updateFacilities
{
    NSDictionary *params = nil;
    NSString *path = @"api/facility";
    [self.httpClient getPath:path parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         for(NSDictionary *dict in results)
             [Facility updateOrCreateFromDictionary:dict];
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [self loginDone:YES tryOffline:NO];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //?? need to end the login process gracefully
         NSLog(@"failed updateFacilities");
         [self loginDone:NO tryOffline:NO];
     }
     ];
}

- (void)loginDone:(BOOL)success tryOffline:(BOOL)offline
{
    if(!success)
        [User logout];
    
    NSDictionary *userInfo = @{@"Success" : @(success),
                               @"TryOffline" : @(offline)};//[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:success] forKey:@"Success"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginDone" object:nil userInfo:userInfo];
}

- (void)updateInspections
{
    //do the update from the server here
    NSDate *start = [[NSUserDefaults standardUserDefaults] objectForKey:@"startDate"];
    if(start == nil)
    {
        start = [NSDate startOfTheWeekFromToday];
        [[NSUserDefaults standardUserDefaults] setObject:start forKey:@"startDate"];
    }
    NSDate *end = [[NSUserDefaults standardUserDefaults] objectForKey:@"endDate"];
    if(end == nil)
    {
        end = [NSDate dateWithNumberOfDays:DEFAULT_NUM_WEEKS*7 sinceDate:start];
        [[NSUserDefaults standardUserDefaults] setObject:end forKey:@"endDate"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self updateInspectionsFromDate:start toDate:end];
}

- (void)updateInspectionsFromDate:(NSDate *)dateFrom toDate:(NSDate *)dateTo
{
    NSDictionary *params = nil; //@{@"Authorization" : USER_TEMP_KEY, @"Content-Type" : @"application/json"};
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yy"];
    
    [SVProgressHUD showWithStatus:@"Updating Inspections"];
    
//    NSString *path = [NSString stringWithFormat:@"api/schedule/daterange/%@/%@", [formatter stringFromDate:dateFrom], [formatter stringFromDate:dateTo]];
    NSString *path = @"api/v1/inspections/";
    [self.httpClient setDefaultHeader:@"Authorization" value:USER_TEMP_KEY];
    [self.httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    [self.httpClient getPath:path parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSArray *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         if (error) {
             NSLog(@"Error parsing JSON: %@", error.localizedDescription);
         }
         
         [SVProgressHUD showProgress:0 status:@"Updating Inspections"];
         
         self.processingInspections = [[NSMutableArray alloc] init];
         for(NSDictionary *dict in results)
         {
             Inspection *inspection = [Inspection updateOrCreateFromDictionary:dict];
             [self.processingInspections addObject:inspection];
         }
         
         self.numProcessingInspections = self.processingInspections.count;
         
         //?? Download all the questions for each inspection also - i.e. start the inspection
         [self processNextInspection];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD dismiss];
         NSLog(@"failed getscedulesbydaterange with error: %@", error.localizedDescription);
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectionsUpdated" object:nil];
         
     }
     ];
}

- (void)processNextInspection
{
    if(self.processingInspections.count == 0)
    {
        [SVProgressHUD dismiss];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectionsUpdated" object:nil];
        return;
    }
    
    float progress = (float)(self.numProcessingInspections - self.processingInspections.count) / (float)(self.numProcessingInspections);
    [SVProgressHUD showProgress:progress status:@"Updating Inspections"];
    
    Inspection *inspection = [self.processingInspections objectAtIndex:0];
    {
        if([inspection.inspectionID integerValue] == 0)
            [self startInspection:inspection];
        else
            [self getQuestionsForInspection2:inspection];
    }
}

- (void)startInspection:(Inspection *)inspection
{
    NSString *path = [NSString stringWithFormat:@"api/inspection/start/%ld/%ld", (long)[inspection.facility.facilityID integerValue], (long)[inspection.scheduleID integerValue]];
    [self.httpClient postPath:path parameters:nil
                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         inspection.inspectionID = [results objectForKey:@"InspectionID"];
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         
         [self getQuestionsForInspection2:inspection];
     }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed startInspection with error: %@", error.localizedDescription);
     }
     ];
}

- (void)getQuestionsForInspection:(Inspection *)inspection
{
    NSArray *types = [[NSArray alloc] initWithObjects:[FormQuestion typeFacility], [FormQuestion typeTanks], [FormQuestion typeDispensers], nil];
    for(NSString *type in types)
    {
        NSString *path = [NSString stringWithFormat:@"api/question/%@/%ld", type, (long)[inspection.inspectionID integerValue]];
        [self.httpClient getPath:path parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
             
             NSArray *questions = [results objectForKey:@"Question"];
             
             for(NSDictionary *dict in questions)
                 [FormQuestion updateOrCreateFromDictionary:dict andInspection:inspection andType:type];
             
             [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
             //             [[NSNotificationCenter defaultCenter] postNotificationName:@"questionsUpdated" object:nil];
             
             if(self.processingInspections.count > 0)
                 [self.processingInspections removeObjectAtIndex:0];
             [self processNextInspection];
         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"failed get %@ questions for inspection", type);
         }
         ];
    }
}

- (void)getQuestionsForInspection2:(Inspection *)inspection
{
    //?? only re-download the questions if I don't already have them - this will miss any changes on the server, but who cares
    if(inspection.formQuestions.count > 0)
    {
        if(self.processingInspections.count > 0)
            [self.processingInspections removeObjectAtIndex:0];
        [self processNextInspection];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"api/question/all/%d", [inspection.inspectionID integerValue]];
    [self.httpClient getPath:path parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSError *error;
         NSDictionary *results = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
         
         NSDictionary *facility = results[@"Facility"];
         NSArray *facilityQuestions = facility[@"Question"];
         for(NSDictionary *dict in facilityQuestions)
             [FormQuestion updateOrCreateFromDictionary:dict andInspection:inspection andType:[FormQuestion typeFacility]];
         
         NSDictionary *tank = results[@"Tank"];
         NSArray *tankQuestions = tank[@"Question"];
         for(NSDictionary *dict in tankQuestions)
             [FormQuestion updateOrCreateFromDictionary:dict andInspection:inspection andType:[FormQuestion typeTanks]];
         
         NSDictionary *dispenser = results[@"Dispenser"];
         NSArray *dispenserQuestions = dispenser[@"Question"];
         for(NSDictionary *dict in dispenserQuestions)
             [FormQuestion updateOrCreateFromDictionary:dict andInspection:inspection andType:[FormQuestion typeDispensers]];
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         
         if(self.processingInspections.count > 0)
             [self.processingInspections removeObjectAtIndex:0];
         [self processNextInspection];
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"failed get all questions for inspection %d", [inspection.inspectionID integerValue]);
         
         if(self.processingInspections.count > 0)
             [self.processingInspections removeObjectAtIndex:0];
         [self processNextInspection];
     }
     ];
}

- (void)getUpdatedAnswers:(NSArray *)answers
{
    for(NSUInteger i=0; i<answers.count; i++)
    {
        FormAnswer *answer = (FormAnswer *)[answers objectAtIndex:i];
        
        NSString *path = [NSString stringWithFormat:@"api/question/answer/%d", [answer.formQuestion.questionID integerValue]];
        [self.httpClient getPath:path parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSError *error;
             NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
             
             [answer updateFromDictionary:result];
             
             if(i == (answers.count - 1))
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"answersUpdated" object:nil];
         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if(i == (answers.count - 1))
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"answersUpdated" object:nil];
         }
         ];
    }
}


- (void)submitInspection:(Inspection *)inspection  withSignatureImage:(UIImage *)image;
{
    self.postingInspection = inspection;
    self.pauseSubmit = NO;
    self.postAnswerIndex = 0;
    self.signatureImage = image;
    
    [SVProgressHUD showProgress:0 status:@"Submitting..."];
    
    [self postNextAnswer];
}

- (void)pauseSubmission
{
    if(self.postingInspection)
        self.pauseSubmit = YES;
}

- (void)restartSubmission
{
    if(self.postingInspection)
    {
        self.pauseSubmit = NO;
        [self postNextAnswer];
    }
}

- (void)postNextAnswer
{
    if(self.pauseSubmit)
        return;
    
    FormQuestion *question = [[self.postingInspection.formQuestions allObjects] objectAtIndex:self.postAnswerIndex];
    
    NSString *path = [NSString stringWithFormat:@"api/question/saveanswer"];
    
    NSDictionary *params = @{@"InspectionID" : self.postingInspection.inspectionID,
                             @"QuestionID" : question.questionID,
                             @"Answer" : [question.formAnswer answerText],
                             @"Comments" : [question.formAnswer commentText] };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableData *body = [NSMutableData data];
    [body appendData:jsonData];
    
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:path parameters:nil/*params*/];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    [self.httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self saveDeficiency];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"failed post answer to questionID: %d", [question.questionID integerValue]);
         [self answerDone];
     }];
    
    [operation start];
}

- (void)saveDeficiency
{
    FormQuestion *question = [[self.postingInspection.formQuestions allObjects] objectAtIndex:self.postAnswerIndex];
    if([question.formAnswer.answer integerValue] != kNO)
    {
        [self uploadAnswerPhoto:0];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"api/deficiency/save"];
    
    NSNumber *repaired = question.formAnswer.repairedOnSite;
    if(!repaired)
        repaired = [NSNumber numberWithBool:NO];
    
    NSDictionary *params = @{  @"InspectionID" : self.postingInspection.inspectionID,
                               @"QuestionID" : question.questionID,
                               @"Comments" : [question.formAnswer commentText],
                               @"RepairedOnSite" : repaired }; //?? actually hook this up to UI
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSMutableData *body = [NSMutableData data];
    [body appendData:jsonData];
    
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST" path:path parameters:nil/*params*/];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    [self.httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self uploadAnswerPhoto:0];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"failed post deficiency to questionID: %d", [question.questionID integerValue]);
         [self answerDone];
     }];
    
    [operation start];
}

- (void)uploadAnswerPhoto:(NSInteger)index
{
    FormQuestion *question = [[self.postingInspection.formQuestions allObjects] objectAtIndex:self.postAnswerIndex];
    if(!question.formAnswer.photos)
    {
        [self answerDone];
        return;
    }
    if(index >= question.formAnswer.photos.count)
    {
        [self answerDone];
        return;
    }
    
    Photo *photo = [[question.formAnswer.photos allObjects] objectAtIndex:index];
    if([photo.uploaded boolValue])
    {
        [self uploadAnswerPhoto:index+1];
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"api/question/attachimage/%d/%d", [question.inspection.inspectionID integerValue], [question.questionID integerValue]];
    if([question.formAnswer.answer integerValue] == kNO)
        path = [NSString stringWithFormat:@"api/deficiency/attachimage/%d/%d", [question.inspection.inspectionID integerValue], [question.questionID integerValue]];
    
    NSMutableURLRequest *request;
    request = [self.httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
               {
                   [formData appendPartWithFileData:photo.jpgData name:@"photo" fileName:@"photofile.jpg" mimeType:@"image/jpeg"];
               }];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success Block Hit!, %@", responseObject);
        photo.uploaded = [NSNumber numberWithBool:YES];
        [self uploadAnswerPhoto:index+1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to upload photo");
        [self answerDone];
    }];
    
    [operation start];
}

- (void)answerDone
{
    [SVProgressHUD showProgress:((float)self.postAnswerIndex / (float)self.postingInspection.formQuestions.count) status:@"Submitting..."];
    self.postAnswerIndex++;
    
    if(self.postAnswerIndex < self.postingInspection.formQuestions.count)
        [self postNextAnswer];
    else
        [self closeInspection];
}

- (void)closeInspection
{
    int minutes = (int)(([self.postingInspection.totalTime floatValue] / 60.0) + 0.5);
    
    NSString *path = [NSString stringWithFormat:@"api/inspection/close/%d/%d/%d", [self.postingInspection.inspectionID integerValue], [self.postingInspection.facility.facilityID integerValue], minutes];
    
    NSMutableURLRequest *request;
    request = [self.httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
               {
                   [formData appendPartWithFileData:UIImageJPEGRepresentation(self.signatureImage, 1.0) name:@"photo" fileName:@"photofile.jpg" mimeType:@"image/jpeg"];
               }];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.postingInspection.submitted = [NSNumber numberWithBool:YES];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        self.postingInspection = nil;
        [SVProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectionSubmitted" object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.postingInspection.submitted = [NSNumber numberWithBool:NO];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        self.postingInspection = nil;
        [SVProgressHUD showImage:nil status:@"Failed to submit inspection"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inspectionSubmitted" object:nil];
    }];
    
    [operation start];
}






@end
