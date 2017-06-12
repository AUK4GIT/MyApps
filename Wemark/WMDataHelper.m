//
//  WMDataHelper.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 25/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMDataHelper.h"
#import "WMUser.h"
#import "WMLocation.h"
#import "WMAssignment.h"

@implementation WMDataHelper
{
    WMUser *auditor;
    NSMutableArray *locationsArray;
    NSMutableArray *assignmentsArray;
}
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WMDataHelper *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WMDataHelper alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        locationsArray = [[NSMutableArray alloc] init];
        assignmentsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setAuditorProfileDetails:(NSDictionary *)dict {
    
    if (auditor == nil) {
        auditor = [[WMUser alloc] init];
    }
    auditor.userid = [self convertToString:dict[@"id"]];
    auditor.usermailid = [self convertToString:dict[@"email"]];
    auditor.username = [self convertToString:dict[@"username"]];
    auditor.firstname = [self convertToString:dict[@"auditor_fname"]];
    auditor.lastname = [self convertToString:dict[@"auditor_lname"]];
    auditor.dob = [self convertToString:dict[@"auditor_dob"]];
    auditor.authkey = [self convertToString:dict[@"auth_key"]];
    auditor.phonenumber = [self convertToString:dict[@"auditor_phone_number_mobile"]];
    auditor.country = [self convertToString:dict[@"auditor_address_country"]];
    auditor.city = [self convertToString:dict[@"auditor_address_city"]];
    auditor.permanentaddress = [self convertToString:dict[@"auditor_permanent_address"]];
    auditor.permanentpincode = [self convertToString:dict[@"auditor_permanent_address_pincode"]];
     auditor.profileImageurlstring = [self convertToString:dict[@"profile_image"]];
}

- (NSArray *)saveLocations:(NSArray *)locarray {
    [locationsArray removeAllObjects];
    for ( NSDictionary *dict in locarray) {
        WMLocation *location = [[WMLocation alloc] init];
        location.address = [self convertToString:dict[@"address"]];
        location.area = [self convertToString:dict[@"area"]];
        location.billingterms = [self convertToString:dict[@"billing_terms"]];
        location.billtoaddress = [self convertToString:dict[@"billto_address"]];
        location.billtocity = [self convertToString:dict[@"billto_city"]];
        location.billtocountry = [self convertToString:dict[@"billto_country"]];
        location.billtoemail = [self convertToString:dict[@"billto_email"]];
        location.billtoname = [self convertToString:dict[@"billto_name"]];
        location.billtostate = [self convertToString:dict[@"billto_state"]];
        location.city = [self convertToString:dict[@"city"]];
        location.clientdescription = [self convertToString:dict[@"client_description"]];
        location.clientemail = [self convertToString:dict[@"client_email"]];
        location.clientid = [self convertToString:dict[@"client_id"]];
        location.clientlocationid = [self convertToString:dict[@"client_location_id"]];
        location.clientname = [self convertToString:dict[@"client_name"]];
        location.clientphnnumber = [self convertToString:dict[@"client_phn_number"]];
        location.clientsince = [self convertToString:dict[@"client_since"]];
        location.contactemail = [self convertToString:dict[@"contact_email"]];
        location.contactfname = [self convertToString:dict[@"contact_fname"]];
        location.contactlname = [self convertToString:dict[@"contact_lname"]];
        location.contactphnnumber = [self convertToString:dict[@"contact_phn_number"]];
        location.country = [self convertToString:dict[@"country"]];
        location.dashboardbg = [self convertToString:dict[@"dashboard_bg"]];
        location.lat = [self convertToString:dict[@"lat"]];
        location.lng = [self convertToString:dict[@"lng"]];
        location.locationaddress = [self convertToString:dict[@"location_address"]];
        location.locationcode = [self convertToString:dict[@"location_code"]];
        location.locationpincode = [self convertToString:dict[@"location_pincode"]];
        location.locationtitle = [self convertToString:dict[@"location_title"]];
        location.logo = [self convertToString:dict[@"logo"]];
        location.postalcode = [self convertToString:dict[@"postal_code"]];
        location.state = [self convertToString:dict[@"state"]];
        location.subarea = [self convertToString:dict[@"subarea"]];
        location.timezone = [self convertToString:dict[@"timezone"]];
        location.type = [self convertToString:dict[@"type"]];
        [locationsArray addObject:location];
    }
    return (NSArray *)locationsArray;
}

- (NSArray *)saveAssignments:(NSArray *)assgnArray {
    [assignmentsArray removeAllObjects];
    for ( NSDictionary *dict in assgnArray) {
        WMAssignment *assignment = [[WMAssignment alloc] init];
        assignment.campaignid = [self convertToString:dict[@"campaign_id"]];
        assignment.clientid = [self convertToString:dict[@"client_id"]];
        assignment.campaigntitle = [self convertToString:dict[@"campaign_title"]];
        assignment.questionnaire = [self convertToString:dict[@"questionnaire_id"]];
        assignment.startdate = [self convertToString:dict[@"start_date"]];
        assignment.enddate = [self convertToString:dict[@"end_date"]];
        assignment.fees = [self convertToString:dict[@"fees"]];
        assignment.isautoassign = [self convertToString:dict[@"is_autoassign"]];
        assignment.minage = [self convertToString:dict[@"min_age"]];
        assignment.minrating = [self convertToString:dict[@"min_rating"]];
        assignment.genderpref = [self convertToString:dict[@"gender_pref"]];
        assignment.citypref = [self convertToString:dict[@"city_pref"]];
        assignment.campaignbudget = [self convertToString:dict[@"campaign_budget"]];
        assignment.reimbursementamount = [self convertToString:dict[@"reimbursement_amount"]];
        assignment.travelallowance = [self convertToString:dict[@"travel_allowance"]];
        assignment.otherexpense = [self convertToString:dict[@"other_expense"]];
        assignment.benchmarkid = [self convertToString:dict[@"benchmark_id"]];
        assignment.status = [self convertToString:dict[@"status"]];
        assignment.createdat = [self convertToString:dict[@"created_at"]];
        assignment.updatedat = [self convertToString:dict[@"updated_at"]];
        assignment.isdeleted = [self convertToString:dict[@"is_deleted"]];
        assignment.assignmentid = [self convertToString:dict[@"assignment_id"]];
        assignment.locationid = [self convertToString:dict[@"location_id"]];
        assignment.assignmentto = [self convertToString:dict[@"assignment_to"]];
        assignment.assignmentstatus = [self convertToString:dict[@"assignment_status"]];
        assignment.assignmentduedate = [self convertToString:dict[@"assignment_due_date"]];
        assignment.logoURL = [self convertToString:dict[@"logo"]];
        [assignmentsArray addObject:assignment];
    }
    return (NSArray *)assignmentsArray;
}


- (NSString *)getAuthKey {
    if (auditor ) {
        return @"N1_EfKJU3ktZSU-yJw_VTJz63M5ZLsId";// auditor.authkey;
    } else {
//        NSAssert(auditor, @"authkey key  not found as auditor object is empty");
        return @"";
    }
}

- (id)getAuditor {
    if (auditor ) {
        return auditor;
    } else {
            NSAssert(auditor, @"auditor object is empty");
        return @"";
    }
}

- (NSString *)getAuditorId {
    if (auditor ) {
        return @"7";//auditor.userid;
    } else {
        //        NSAssert(auditor, @"authkey key  not found as auditor object is empty");
        return @"";
    }
}


- (NSString *)convertToString:(id)value {
    if (value == (id)[NSNull null]) {
        return @"";
    } else if ([value isKindOfClass:[NSNumber class]]){
        return [value stringValue];
    } else if ([value isKindOfClass:[NSString class]]){
        return value;
    } else {
        return value;
    }
}
@end
