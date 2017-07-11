//
//  WMConstants.m
//  Wemark
//
//  Created by Kiran Reddy on 25/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMConstants.h"

NSString * const baseURL = @"http://wemark.trionhost.com/";
NSString * const loginURL = @"auditor-api/auth/login";
NSString * const registerURL = @"auditor-api/auth/register";
NSString * const getAllLocationsURL = @"auditor-api/locations/get-all-locations";
NSString * const assignmentsByLocationURL = @"auditor-api/assignments/get-all-assignment-from-location-name";
NSString * const getAllSearchParams = @"auditor-api/campaigns/get-all-search-parameters";
NSString * const searchCampaignAssignmentsURL = @"auditor-api/campaigns/search-campaign-assignments";
NSString * const getNotificationsforAuditorURL = @"auditor-api/notification/get-notification-by-auditor-id";
NSString * const getAssignmentsforAuditorURL = @"auditor-api/assignments/my-assignments";
NSString * const getAllAssignmentsByClientIdURL = @"auditor-api/assignments/get-all-assignment-from-client-id";
NSString * const getAuditorCampaignViewDetails = @"auditor-api/campaigns/campaign-view-details";
NSString * const getAllCountriesURL = @"auditor-api/campaigns/get-all-countries";
NSString * const getAllStatesByCountryNameURL = @"auditor-api/campaigns/get-all-states-by-country-name";
NSString * const getAllCitiesByStateNameURL = @"auditor-api/campaigns/get-all-cities-by-state-name";
NSString * const getAuditorTransactionHistoryURL = @"auditor-api/transaction/auditor-transaction-history";
NSString * const changeAuditorPasswordURL = @"auditor-api/auditor/change-auditor-password";
NSString * const editProfileURL = @"auditor-api/auditor/edit-profile";
NSString * const getProfileURL = @"auditor-api/auditor/get-auditor-profile";
NSString * const submitQuestionnaireAnswerURL = @"auditor-api/questionnaire/questions-answers";
NSString * const forgotAuditorPasswordURL = @"auditor-api/auth/forgot-password";
NSString *const sendOTPURL = @"auditor-api/auth/resend-otp";
NSString *const verifyOTPURL = @"auditor-api/auth/verify-otp";
NSString *const facebookAuditorLoginURL = @"auditor-api/auth/facebook-login";
NSString *const startSurveyURL = @"auditor-api/questionnaire/get-all-sections-by-questionnaire-id";
NSString *const questionaireURL = @"auditor-api/questionnaire/get-questions-by-assignment-id-and-section-id";
NSString *const questionaireImageUploadURL = @"auditor-api/questionnaire/questionnaire-image-upload";
NSString *const questionaireDeleteFileURL = @"questionnaire/delete-file";

