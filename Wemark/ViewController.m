//
//  ViewController.m
//  Wemark
//
//  Created by Kiran Reddy on 23/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "ViewController.h"
#import "ACFloatingTextField.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ACFloatingTextField *emailIdTextField;
@property (weak, nonatomic) IBOutlet ACFloatingTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) IBOutlet UIView *fbLoginButton;
@end

@implementation ViewController
{
    UIActivityIndicatorView *activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.fbLoginButton.backgroundColor = [UIColor clearColor];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
//    loginButton.frame = self.fbLoginButton.bounds;
//    [self.fbLoginButton addSubview:loginButton];
//    loginButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
//    loginButton.readPermissions =
//    @[@"public_profile", @"email"];
//    [loginButton removeTarget:nil
//                       action:NULL
//             forControlEvents:UIControlEventAllEvents];
//    [loginButton
//     addTarget:self
//     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tintColor = [UIColor whiteColor];
    [activityView setHidesWhenStopped:true];
    [self.view addSubview:activityView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)loginUsingFacebook:(id)result {
    [activityView startAnimating];
    __block NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];
    
    void (^loginBlock)(void) =  ^{
        WMWebservicesHelper *helper = [WMWebservicesHelper sharedInstance];
        
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:[result valueForKey:@"email"] forKey:@"email_id"];
        [dataDict setValue:[[UIDevice currentDevice] model] forKey:@"device_type"];
        [dataDict setValue:[result valueForKey:@"id"] forKey:@"fb_id"];
        [dataDict setValue:version forKey:@"app_version_ios"];
        [dataDict setValue:deviceToken forKey:@"iphone_device_token"];
        [helper facebookAuditorLogin:dataDict completionBlock:^(BOOL result, id responseDict, NSError *error) {
            NSLog(@"result:-> %@",result ? @"success" : @"Failed");
            if (result) {
                [[WMDataHelper sharedInstance] setAuditorProfileDetails:responseDict];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate loadhomeScreenWithSidemenu];
            } else {
                NSDictionary *resDict = responseDict;
                if ([resDict[@"code"] integerValue] == 409) {
                    NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self showErrorMessage:resDict[@"message"]];
                    });
                }  else
                    NSLog(@"Error:->  %@",error.localizedDescription);
                }
            //add UI related code here like stopping activity indicator
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView stopAnimating];
            });
        }];
    };
    
    if (deviceToken) {
        loginBlock();
    } else {
        deviceToken = @"740f4707bebcf74f 9b7c25d4 8e3358945f6aa01d a5ddb387462c7eaf61bb78ad";
        loginBlock();
    }
}

// Once the button is clicked, show the login dialog
-(IBAction)loginButtonClicked:(id)sender
{
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,email,first_name,last_name,birthday"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", result);
                         [self loginUsingFacebook:result];
                     } else {
                         
                     }
                 }];
            }
        
    }else {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             if ([result.grantedPermissions containsObject:@"email"]) {
                 if ([FBSDKAccessToken currentAccessToken]) {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,email,first_name,last_name,birthday"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          if (!error) {
                              NSLog(@"fetched user:%@", result);
                               [self loginUsingFacebook:result];
                          } else {
                          
                          }
                      }];
                 }
             }
         }
     }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)proceedWithLogin:(NSString *)userid password:(NSString *)password {
    [activityView startAnimating];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"];

    void (^loginBlock)(void) =  ^{
        WMWebservicesHelper *helper = [WMWebservicesHelper sharedInstance];
        
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:userid forKey:@"email_id"];
        [dataDict setValue:password forKey:@"password"];
        [dataDict setValue:[[UIDevice currentDevice] model] forKey:@"device_type"];
        [dataDict setValue:version forKey:@"app_version_ios"];
        [dataDict setValue:deviceToken forKey:@"iphone_device_token"];
        [helper loginAuditorWithdata:dataDict completionBlock:^(BOOL result, id responseDict, NSError *error) {
            NSLog(@"result:-> %@",result ? @"success" : @"Failed");
            if (result) {
                [[WMDataHelper sharedInstance] setAuditorProfileDetails:responseDict];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate loadhomeScreenWithSidemenu];
            } else {
                NSDictionary *resDict = responseDict;
                if ([resDict[@"code"] integerValue] == 409) {
                    NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                }  else if ([resDict[@"code"] integerValue] == 401) {
                    NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                    [self showEnterPhoneNumberUI:resDict[@"message"]];
                }  else if ([resDict[@"code"] integerValue] == 402) {
                    NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                    [self showErrorMessage:resDict[@"message"]];
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
        loginBlock();
    } else {
        deviceToken = @"740f4707bebcf74f 9b7c25d4 8e3358945f6aa01d a5ddb387462c7eaf61bb78ad";
        loginBlock();
    }
}

- (void)showVerifyOTPUI {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Enter OTP" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resendAction = [UIAlertAction actionWithTitle:@"Resend OTP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendOTP];
    }];
    UIAlertAction *verifyAction = [UIAlertAction actionWithTitle:@"Verify OTP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *otp = alertController.textFields.firstObject;
        if (otp.text.length > 0) {
            [self verifyOTPEntered:otp.text];
        }
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter OTP";
     }];
    [alertController addAction:resendAction];
    [alertController addAction:verifyAction];
    
    [self presentViewController:alertController animated:true completion:^{
    }];
}

- (void)showEnterPhoneNumberUI:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resendAction = [UIAlertAction actionWithTitle:@"Send OTP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *otp = alertController.textFields.firstObject;
        if (otp.text.length > 0) {
            self.mobileNumber = otp.text;
             [self sendOTP];
        }
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter phone number";
     }];
    [alertController addAction:resendAction];
    
    [self presentViewController:alertController animated:true completion:^{
    }];
}

- (void)verifyOTPEntered:(NSString *)otp {
    [[WMWebservicesHelper sharedInstance] verifyOTP:@{@"code":otp,@"mobile":self.mobileNumber} completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self proceedWithLogin:self.emailIdTextField.text password:self.passwordTextField.text];
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
            [activityView stopAnimating];
        });
        
    }];
}

- (void)sendOTP {
    [[WMWebservicesHelper sharedInstance] sendOTP:[[WMDataHelper sharedInstance]
     getAuthKey] toMobileNumber:self.mobileNumber completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showVerifyOTPUI];
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
            [activityView stopAnimating];
        });
    }];
}

- (IBAction)loginAction :(id)sender {
    
//    self.emailIdTextField.text = @"vikas1@gmail.com";
//    self.passwordTextField.text = @"123456";
    
    if (![self isValidEmail:self.emailIdTextField.text]) {
        NSLog(@"Invalid Email Address");
        [self.emailIdTextField showErrorWithText:@"Please type a valid email id"];
    } else if (self.passwordTextField.text.length == 0){
        [self.passwordTextField showErrorWithText:@"Password you entered is incorrect"];
    } else {
        [self proceedWithLogin:self.emailIdTextField.text password:self.passwordTextField.text];
    }
}

- (void)viewWillLayoutSubviews {
    activityView.center = self.view.center;
}
#pragma mark - UITextFieldDelegates

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//}
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
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//
//}

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

- (void)showErrorMessage:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    //    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:true completion:^{
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}
@end
