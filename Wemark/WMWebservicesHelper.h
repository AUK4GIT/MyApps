//
//  WMWebservicesHelper.h
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 24/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMWebservicesHelper : NSObject
+ (instancetype)sharedInstance;


/**
 Register Service

 @param body request body
 @param completionBlock callback
 */
- (void)loginAuditorWithdata:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock;
/**
 Login service

 @param body request body
 @param completionBlock callback
 */
- (void)registerAuditorWithdata:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock;

/**
 Gets all locations

 @param completionBlock callback
 */
- (void)getAllLocations:(NSString *)authKey withPageNumber:(NSString *)pageNumber completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;


/**
 Get Assignments by LocationId selected

 @param authKey authKey
 @param locId location Id
 @param selfAssign true or false
 @param apply true or false
 @param completionBlock callback
 */
- (void)getAssignments:(NSString *)authKey byLocationId:(NSString *)locId forSelfAssign:(NSString *)selfAssign forApply:(NSString *)apply completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;


/**
 FEtches All Search Parameters

 @param completionBlock callback
 */
- (void)getAllSearchParametersWithCompletionBlock: (void (^) (BOOL, id, NSError*))completionBlock authkey:(NSString *)authKey;


/**
 Fetch filtered assignments

 @param dict start, endDates....
 @param completionBlock callback
 */
- (void)getSearchCampaignAssignments:(NSDictionary *)dict forAuthKey:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;


/**
 get Notifications

 @param authKey authkey
 @param audId audtor id
 @param completionBlock callback
 */
- (void)getNotifications:(NSString *)authKey byAuditorId:(NSString *)audId completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

/**
 get Auditor Assignments
 
 @param authKey authkey
 @param audId audtor id
 @param completionBlock callback
 */
- (void)getAuditorAssignments:(NSString *)authKey paramsDict:(id)paramsDict completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;


/**
 get All Assignments By Client Id
 
 @param authKey authkey
 @param audId audtor id
 @param completionBlock callback
 */
- (void)getAllAssignmentsByClientId:(NSString *)clientId authKey:(NSString *)authKey completionBlock:(void (^)(BOOL, id, NSError *))completionBlock;


- (void)getAuditorProfileforauthKey:(NSString *)authKey completionBlock:(void (^)(BOOL, id, NSError *))completionBlock;

@end
