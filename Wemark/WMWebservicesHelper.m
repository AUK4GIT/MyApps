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
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,loginURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
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

- (void)registerAuditorWithdata:(NSDictionary *)body imageURL:(NSString *)imgURL completionBlock: (void (^) (BOOL, id, NSError*))completionBlock{
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,registerURL] parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *fName = [NSString stringWithFormat:@"%@_%@",[body objectForKey:@"first_name"],[body objectForKey:@"last_name"]];
        if (imgURL) {
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:imgURL] name:fName fileName:[NSString stringWithFormat:@"%@.jpg",fName] mimeType:@"image/jpeg" error:nil];
        }
    } error:nil];

//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPBody:jsonData];

    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
                          NSDictionary *codeDict = responseObject[@"meta"];
                          completionBlock(false,codeDict,error);
                      } else {
                          NSLog(@"%@ ** %@", response, responseObject);
                          completionBlock(true,responseObject[@"data"],nil);
                      }
                  }];
    [uploadTask resume];
}

- (void)getAllLocations:(NSString *)authKey withPageNumber:(NSString *)pageNumber completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
//    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *paramsDict = @{@"page":pageNumber,@"pageSize":@"10"};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,getAllLocationsURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)getAssignments:(NSString *)authKey byLocationId:(NSString *)locId forSelfAssign:(NSString *)selfAssign forApply:(NSString *)apply completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    //    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *paramsDict = @{@"self_assign":selfAssign,@"apply":apply,@"location_id":locId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@?location_id=%@&page=%@&pageSize=%@",baseURL,assignmentsByLocationURL,locId,@"0",@"10"];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,searchCampaignAssignmentsURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:dict error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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



- (void)getAllSearchParametersWithCompletionBlock: (void (^) (BOOL, id, NSError*))completionBlock authkey:(NSString *)authKey{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,getAllSearchParams] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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


- (void)getAuditorAssignments:(NSString *)authKey paramsDict:(id)paramsDict completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    //    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSDictionary *paramsDict = @{@"Applied":applied,@"Assigned":assigned,@"Accepted":accepted,@"Rejected":rejected,@"auditor_id":audId};
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,getAssignmentsforAuditorURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)getAllAssignmentsByClientId:(NSString *)clientId authKey:(NSString *)authKey completionBlock:(void (^)(BOOL, id, NSError *))completionBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@?client_id=%@",baseURL,getAllAssignmentsByClientIdURL,clientId] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)getAuditorProfileforauthKey:(NSString *)authKey completionBlock:(void (^)(BOOL, id, NSError *))completionBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,getProfileURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)getCountries:(NSString *)authKey completionBlock:(void (^) (BOOL,id,NSError *))completionBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]
        requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,getAllCountriesURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *  error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@",error.localizedDescription,
                  responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@",response,responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)getStates:(NSString *)authKey forCountry:(NSString *)countryId completionBlock:(void (^) (BOOL,id,NSError *))completionBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]
                                    requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,getAllStatesByCountryNameURL] parameters:@{@"country_name":countryId} error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *  error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@",error.localizedDescription,
                  responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@",response,responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)getCities:(NSString *)authKey forState:(NSString *)stateId completionBlock:(void (^) (BOOL,id,NSError *))completionBlock {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer]
                                    requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,getAllCitiesByStateNameURL] parameters:@{@"state_name":stateId} error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *  error) {
        if (error) {
            NSLog(@"Error: %@\nMessage: %@",error.localizedDescription,
                  responseObject[@"meta"]);
            NSDictionary *codeDict = responseObject[@"meta"];
            completionBlock(false,codeDict,error);
        } else {
            NSLog(@"%@ ** %@",response,responseObject);
            completionBlock(true,responseObject[@"data"],nil);
        }
    }];
    [dataTask resume];
}

- (void)editProfile:(NSString *)authKey paramsDict:(id )paramsDict profilePicURL:(NSString *)profilePicURL userId:(NSString *)userId completionBlock:(void (^) (BOOL,id,NSError *))completionBlock {
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?id=%@",baseURL,editProfileURL,userId];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSString *fName = [NSString stringWithFormat:@"%@_%@",[paramsDict objectForKey:@"auditor_fname"],[paramsDict objectForKey:@"auditor_lname"]];
        if(profilePicURL) {
            NSError *error;
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:profilePicURL] name:fName fileName:[NSString stringWithFormat:@"%@.jpg",fName] mimeType:@"image/jpeg" error:&error];
            NSLog(@"error: %@",error);
        }
    } error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
//    [request setHTTPBody:jsonData];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
//                          [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@\nMessage: %@", error.localizedDescription, responseObject[@"meta"]);
                          NSDictionary *codeDict = responseObject[@"meta"];
                          completionBlock(false,codeDict,error);
                      } else {
                          NSLog(@"%@ ** %@", response, responseObject);
                          completionBlock(true,responseObject[@"data"],nil);
                      }
                  }];
    
    [uploadTask resume];
    
}

- (void)changeAuditorPassword:(NSString *)authKey oldPassword:(NSString *)oldPwd  newPassword:(NSString *)newPwd  completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"old_password":oldPwd, @"new_password":newPwd} options:NSJSONWritingPrettyPrinted error:&error];

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,changeAuditorPasswordURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
    [request setHTTPBody:jsonData];

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

- (void)forgotAuditorPassword:(NSString *)authKey emailId:(NSString *)emailid    completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"email_id":emailid} options:NSJSONWritingPrettyPrinted error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,forgotAuditorPasswordURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:authKey forHTTPHeaderField:@"Auth-key"];
    [request setHTTPBody:jsonData];
    
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

- (void)getTransactionHistory:(NSString *)authKey completionBlock:(void (^)(BOOL, id, NSError *))completionBlock {
    //    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //NSDictionary *paramsDict = @{@"auditor_id":audId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,getAuditorTransactionHistoryURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)getCampaignViewDetails:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //NSDictionary *paramsDict = @{@"auditor_id":audId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,getAuditorCampaignViewDetails];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)sendOTP:(NSString *)authKey toMobileNumber:(NSString *)mobilenumber completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    //    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSDictionary *paramsDict = @{@"mobile":mobilenumber};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,sendOTPURL];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:paramsDict error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

- (void)verifyOTP:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,verifyOTPURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
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

- (void)facebookAuditorLogin:(id)body completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,facebookAuditorLoginURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    
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

- (void)startSurvey:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",baseURL,startSurveyURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
- (void)submitQuestionnaire:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",baseURL,submitQuestionnaireAnswerURL] parameters:nil error:nil];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
@end
