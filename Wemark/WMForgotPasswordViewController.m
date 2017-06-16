//
//  WMForgotPasswordViewController.m
//  Wemark
//
//  Created by Ashish on 15/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMForgotPasswordViewController.h"
#import "ACFloatingTextField.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "AppDelegate.h"
#import "WMCheckEmailViewController.h"
@interface WMForgotPasswordViewController ()
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailIdTextField;
- (IBAction)resetBtnTapped:(id)sender;

@end

@implementation WMForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Forgot Password";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)proceedWithForgotPassword {
    [self showActivity];
    
    WMWebservicesHelper *helper = [WMWebservicesHelper sharedInstance];
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    
    [helper forgotAuditorPassword:authKey emailId:self.emailIdTextField.text completionBlock:^(BOOL result, id responseDict, NSError *error)  {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            [self navigateToNextScreen];
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

- (void)navigateToNextScreen{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ResendVerificationScreen" sender:nil];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ResendVerificationScreen"]) {
        WMCheckEmailViewController *vc = [segue destinationViewController];
        vc.emailId = self.emailIdTextField.text;
    }
}

- (IBAction)resetBtnTapped:(id)sender {
    
    if (self.emailIdTextField.text.length == 0) {
        NSLog(@"In correct email address");
        [self.emailIdTextField showErrorWithText:@"Please type  correct email Id"];
       } else {
        [self proceedWithForgotPassword];
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

@end
