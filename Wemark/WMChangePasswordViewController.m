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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


@end

@implementation WMChangePasswordViewController
{
    UIActivityIndicatorView * activityView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tintColor = [UIColor whiteColor];
    [activityView setHidesWhenStopped:true];
    [self.view addSubview:activityView];
    
    self.title = @"Change Password";

}

- (void)viewWillLayoutSubviews {
    activityView.center = self.view.center;
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

- (void)proceedWithChangePassword:(NSString *)userid password:(NSString *)password {
    [activityView startAnimating];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];
    
    void (^changePasswordBlock)(void) =  ^{
        WMWebservicesHelper *helper = [WMWebservicesHelper sharedInstance];
        
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:userid forKey:@"email_id"];
        [dataDict setValue:password forKey:@"password"];
        [helper changeAuditorPassword:dataDict completionBlock:^(BOOL result, id responseDict, NSError *error) {
            NSLog(@"result:-> %@",result ? @"success" : @"Failed");
            if (result) {
                [[WMDataHelper sharedInstance] setAuditorProfileDetails:responseDict];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate loadhomeScreenWithSidemenu];
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
                [activityView stopAnimating];
            });
        }];
    };
    
    if (deviceToken) {
        changePasswordBlock();
    } else {
        deviceToken = @"740f4707bebcf74f 9b7c25d4 8e3358945f6aa01d a5ddb387462c7eaf61bb78ad";
        changePasswordBlock();
    }
}

- (void)changePassword {
    
    self.currentPasswordTextField.text = @"";
    self.changePasswordTextField.text = @"";
    self.confirmPasswordTextField.text = @"";
    
    if (![self isValidEmail:self.currentPasswordTextField.text]) {
        NSLog(@"wrong password");
        [self.currentPasswordTextField showErrorWithText:@"Please type  current password"];
    } else if (self.changePasswordTextField.text.length == 0){
        [self.changePasswordTextField showErrorWithText:@"Password you entered is incorrect"];
    } else  if (self.confirmPasswordTextField.text.length == 0){
        [self.confirmPasswordTextField showErrorWithText:@"Confirm your password"];
    }
}

#pragma mark - UITextFieldDelegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.topConstraint.constant = -350;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.topConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    self.topConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setNeedsLayout];
    }];
}

-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}


@end
