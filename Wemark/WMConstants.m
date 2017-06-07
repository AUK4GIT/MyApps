//
//  WMConstants.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 25/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMConstants.h"

NSString *  const baseURL = @"http://wemark.trionhost.com/";
NSString * const loginURL = @"auditor-api/auth/login";
NSString * const registerURL = @"auditor-api/auth/register";
NSString * const getAllLocationsURL = @"auditor-api/locations/get-all-locations";
NSString * const assignmentsByLocationURL = @"auditor-api/assignments/get-all-assignment-from-location-id";
NSString * const getAllSearchParams = @"auditor-api/campaigns/get-all-search-parameters";
NSString * const searchCampaignAssignmentsURL = @"auditor-api/campaigns/search-campaign-assignments";
NSString * const getNotificationsforAuditorURL = @"auditor-api/notification/get-notification-by-auditor-id";
NSString * const getAssignmentsforAuditorURL = @"auditor-api/assignments/my-assignments";
//NSString * const getAllAssignmentsByLocationIdURL = @"auditor-api/assignments/get-all-assignment-from-location-id";
NSString * const getAllAssignmentsByClientIdURL = @"auditor-api/assignments/get-all-assignment-from-client-id";
