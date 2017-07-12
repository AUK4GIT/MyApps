//
//  WMVerifyOTPViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 11/07/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMVerifyOTPViewController.h"
#import "ACFloatingTextField.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"

@interface WMVerifyOTPViewController ()
@property (weak, nonatomic) IBOutlet ACFloatingTextField *otpTextField;

@end

@implementation WMVerifyOTPViewController
- (IBAction)verifyOTPAction:(id)sender {
    [[WMWebservicesHelper sharedInstance] verifyOTP:@{@"code":self.otpTextField.text,@"mobile":self.mobileNumber} completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:true];
            });
        }else{
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"]
                 integerValue] == 409) {
                NSLog(@"Error responseDict:->%@",resDict[@"message"]);
            }else{
                NSLog(@"Error:->%@",error.localizedDescription);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            [activityView stopAnimating];
        });
        
    }];
}

- (IBAction)resendOTPAction:(id)sender {
    [[WMWebservicesHelper sharedInstance] sendOTP:[[WMDataHelper sharedInstance]
                                                   getAuthKey] toMobileNumber:self.mobileNumber completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self showVerifyOTPUI];
            });
        }else{
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"]
                 integerValue] == 409) {
                NSLog(@"Error responseDict:->%@",resDict[@"message"]);
            }else{
                NSLog(@"Error:->%@",error.localizedDescription);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            [activityView stopAnimating];
        });
        
    }];
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
