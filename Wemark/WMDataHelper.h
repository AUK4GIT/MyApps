//
//  WMDataHelper.h
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 25/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMDataHelper : NSObject
+ (instancetype)sharedInstance;
- (void)setAuditorProfileDetails:(NSDictionary *)dict;
- (NSString *)getAuthKey;
- (NSArray *)saveLocations:(NSArray *)locarray;
- (NSArray *)saveAssignments:(NSArray *)assgnArray;
- (NSString *)getAuditorId;
- (NSString *)getAuditorAssignments:(NSArray *)auditorAssgnArray;
@end

