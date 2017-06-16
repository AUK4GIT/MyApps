//
//  WMCheckEmailViewController.m
//  Wemark
//
//  Created by Ashish on 15/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMCheckEmailViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"

@interface WMCheckEmailViewController ()

@end

@implementation WMCheckEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resendForgotPasswordLink {
    [self showActivity];
    
    WMWebservicesHelper *helper = [WMWebservicesHelper sharedInstance];
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    
    [helper forgotAuditorPassword:authKey emailId:self.emailId completionBlock:^(BOOL result, id responseDict, NSError *error)  {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            
        } else {
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"] integerValue] == 409) {
                NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                [self showErrorMessage:resDict[@"message"]];
            } else {
                NSLog(@"Error:->  %@",error.localizedDescription);
            }
        }
        //add UI related code here like stopping activity indicator
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideActivity];
        });
    }];
}

- (IBAction)navigateToSignin:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
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
