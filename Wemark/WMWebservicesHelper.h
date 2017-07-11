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
- (void)registerAuditorWithdata:(NSDictionary *)body imageURL:(NSString *)imgURL completionBlock: (void (^) (BOOL, id, NSError*))completionBlock;

/**
 Gets all locations

 @param completionBlock callback
 */
- (void)getAllLocations:(NSString *)authKey withPageNumber:(NSString *)pageNumber completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;


/**
 Get Assignments by LocationId selected

 @param authKey authKey
 @param locName location Name
 @param selfAssign true or false
 @param apply true or false
 @param completionBlock callback
 */
- (void)getAssignments:(NSString *)authKey byLocationName:(NSString *)locName  locationId:(NSString *)locationId forSelfAssign:(NSString *)selfAssign forApply:(NSString *)apply completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

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

- (void)editProfile:(NSString *)authKey paramsDict:(id )paramsDict profilePicURL:(NSString *)profilePicURL userId:(NSString *)userId completionBlock:(void (^) (BOOL,id,NSError *))completionBlock;

- (void)getAuditorProfileforauthKey:(NSString *)authKey completionBlock:(void (^)(BOOL, id, NSError *))completionBlock;

- (void)getCountries:(NSString *)authKey completionBlock:(void (^) (BOOL,id,NSError *))completionBlock;

- (void)getStates:(NSString *)authKey forCountry:(NSString *)countryId completionBlock:(void (^) (BOOL,id,NSError *))completionBlock ;

- (void)getCities:(NSString *)authKey forState:(NSString *)stateId completionBlock:(void (^) (BOOL,id,NSError *))completionBlock;

- (void)changeAuditorPassword:(NSString *)authKey oldPassword:(NSString *)oldPwd  newPassword:(NSString *)newPwd  completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)forgotAuditorPassword:(NSString *)authKey emailId:(NSString *)emailid    completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)getTransactionHistory:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)verifyOTP:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock;

- (void)sendOTP:(NSString *)authKey toMobileNumber:(NSString *)mobilenumber completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)getCampaignViewDetails:(NSString *)authKey withCampaignId:campaignId completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)facebookAuditorLogin:(id)body completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)startSurvey:(NSString *)authKey forQuestionnairId:(NSString *)questionnaireId forAssignmentId:(NSString *)assignmentId completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)submitQuestionnaire:(NSString *)authKey completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)getQuestionaire:authKey forAssignmentId:assignmentId forSectionId:sectionId completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

- (void)getQuestionaireImageUpload:authKey forQuestionId:(NSString *)questionid withImageURL:(NSString *)imgURL  completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;

//- (void)loginAuditorWithdata:(NSDictionary *)body completionBlock: (void (^) (BOOL, id, NSError*))completionBlock;
- (void)getQuestionaireDeleteFile:authKey forAssignmentId:assignmentId forSectionId:sectionId completionBlock:(void (^) (BOOL, id, NSError*))completionBlock;
@end
