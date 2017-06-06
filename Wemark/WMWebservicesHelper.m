//
//  WMWebservicesHelper.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 24/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMWebservicesHelper.h"
#import "AFNetworking.h"
#import "WMConstants.h"

@implementation WMWebservicesHelper
{
    NSURLSessionConfiguration *sessionConfig;
}
+ (instancetype)sharedInstance {
    static WMWebservicesHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WMWebservicesHelper alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    return self;
}

- (void)loginAuditorWithdata:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,loginURL] parameters:nil error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonString length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)registerAuditorWithdata:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,registerURL] parameters:nil error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonString length]];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }

    }];
    [dataTask resume];
}

- (void)getAllLocations:(NSString *)authKey withPageNumber:(NSString *)pageNumber completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
//    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *paramsDict = @{@"page":pageNumber,@"pageSize":@"10"};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,getAllLocationsURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonString length]];
//    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)getAssignments:(NSString *)authKey byLocationId:(NSString *)locId forSelfAssign:(NSString *)selfAssign forApply:(NSString *)apply completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    //    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *paramsDict = @{@"self_assign":selfAssign,@"apply":apply,@"location_id":locId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@?location_id=%@&page=%@&pageSize=%@",baseURL,assignmentsByLocationURL,locId,@"0",@"10"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
//    [request addValue:locId forHTTPHeaderField:@"location_id"];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)getSearchCampaignAssignments:(NSDictionary *)dict forAuthKey:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,searchCampaignAssignmentsURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:dict error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
//    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonString length]];
//    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}



- (void)getAllSearchParametersWithCompletionBlock: (void (^) (BOOL, id, NSError*))completionBlock authkey:(NSString *)authKey{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,getAllSearchParams] parameters:nil error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)getNotifications:(NSString *)authKey byAuditorId:(NSString *)audId completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    //    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *paramsDict = @{@"auditor_id":audId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@?auditor_id=%@",baseURL,getNotificationsforAuditorURL,audId];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@", response, responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

/*
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
 } error:nil];
 
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 
 NSURLSessionUploadTask *uploadTask;
 uploadTask = [manager
 uploadTaskWithStreamedRequest:request
 progress:^(NSProgress * _Nonnull uploadProgress) {
 // This is not called back on the main queue.
 // You are responsible for dispatching to the main queue for UI updates
 dispatch_async(dispatch_get_main_queue(), ^{
 //Update the progress view
 [progressView setProgress:uploadProgress.fractionCompleted];
 });
 }
 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"%@ %@", response, responseObject);
 }
 }];
 
 [uploadTask resume];
 
 */

@end
