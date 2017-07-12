//
//  WMChangePasswordViewController.m
//  Wemark
//
//  Created by Ashish on 09/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMChangePasswordViewController.h"
#import "ACFloatingTextField.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "AppDelegate.h"

@interface WMChangePasswordViewController ()
@property (strong, nonatomic) IBOutlet ACFloatingTextField *currentPasswordTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *changePasswordTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *confirmPasswordTextField;
@end

@implementation WMChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Change Password";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    //self.navigationController.navigationBar.backItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)proceedWithChangePassword {
    [self showActivity];
    
        WMWebservicesHelper *helper = [WMWebservicesHelper sharedInstance];
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];

        [helper changeAuditorPassword:authKey oldPassword:self.currentPasswordTextField.text newPassword:self.changePasswordTextField.text  completionBlock:^(BOOL result, id responseDict, NSError *error) {
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

- (IBAction)changePassword {
    
    if (self.currentPasswordTextField.text.length == 0) {
        NSLog(@"wrong password");
        [self.currentPasswordTextField showErrorWithText:@"Please type  current password"];
    } else if (self.changePasswordTextField.text.length == 0){
        [self.changePasswordTextField showErrorWithText:@"Please type  new password"];
    } else  if (self.confirmPasswordTextField.text.length == 0){
        [self.confirmPasswordTextField showErrorWithText:@"Please type  confirm password"];
    } else if (![self.confirmPasswordTextField.text isEqualToString:self.changePasswordTextField.text]) {
        [self.confirmPasswordTextField showErrorWithText:@"password not match"];
        [self.changePasswordTextField showErrorWithText:@"password not match"];
    } else {
        [self proceedWithChangePassword];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}


@end
