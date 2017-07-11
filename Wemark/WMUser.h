//
//  WMUser.h
//  Wemark
//
//  Created by Kiran Reddy on 25/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMUser : NSObject
@property(nonatomic, strong) NSString *userid;
@property(nonatomic, strong) NSString *usermailid;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *authkey;
@property(nonatomic, strong) NSString *firstname;
@property(nonatomic, strong) NSString *lastname;
@property(nonatomic, strong) NSString *phonenumber;
@property(nonatomic, strong) NSString *profileImageurlstring;
@property(nonatomic, strong) NSString *dob;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *permanentaddress;
@property(nonatomic, strong) NSString *permanentpincode;
@end
