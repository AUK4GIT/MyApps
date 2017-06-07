//
//  WMAllAssignmentsClientIdViewController.m
//  Wemark
//
//  Created by Ashish on 06/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMAllAssignmentsClientIdViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"

@interface WMAllAssignmentsClientIdViewController ()

@end

@implementation WMAllAssignmentsClientIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];

    [[WMWebservicesHelper sharedInstance] getAllAssignmentsByClientId:self.clientid authKey:authKey  completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
//            self.assignmentsArray = [NSMutableArray arrayWithArray:[[WMDataHelper sharedInstance] saveAssignments:responseDict]];
        } else {
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"] integerValue] == 409) {
                NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
            } else {
                NSLog(@"Error:->  %@",error.localizedDescription);
            }
        }
        //add UI related code here like stopping activity indicator
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [activityView stopAnimating];
//            [self.tableView reloadData];
        });

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
