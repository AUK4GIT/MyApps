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
@end

@implementation ViewController
{
    UIActivityIndicatorView *activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tintColor = [UIColor whiteColor];
    [activityView setHidesWhenStopped:true];
    [self.view addSubview:activityView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
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

- (IBAction)loginAction :(id)sender {
    
    self.emailIdTextField.text = @"vikas1@gmail.com";
    self.passwordTextField.text = @"123456";
    
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


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}
@end
