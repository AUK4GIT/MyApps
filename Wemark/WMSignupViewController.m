//
//  WMSignupViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 23/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMSignupViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "ACFloatingTextField.h"
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <QuartzCore/QuartzCore.h>

@interface WMSignupViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailIdTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *verifyOTPTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *mobileNumberTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImgView;
//@property (strong, nonatomic) IBOutlet NSString;
@property (strong, nonatomic) NSString *profilePicURL;
- (IBAction)signUpBtnTapped:(id)sender;
- (IBAction)signInBtnTapped:(id)sender;
@end

@implementation WMSignupViewController
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
    
    self.title = @"Sign up";
    
    if (self.facebookprofile) {
        self.firstNameTextField.text = [self.facebookprofile valueForKey:@"first_name"];
        self.lastNameTextField.text = [self.facebookprofile valueForKey:@"last_name"];
        self.emailIdTextField.text = [self.facebookprofile valueForKey:@"email"];
    }
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

- (void)verifyOTPEntered:(NSString *)otp {
    [[WMWebservicesHelper sharedInstance] verifyOTP:@{@"code":otp,@"mobile":self.mobileNumberTextField.text} completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
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
            [activityView stopAnimating];
        });
        
    }];
}

- (void)sendOTP {
    [[WMWebservicesHelper sharedInstance] sendOTP:[[WMDataHelper sharedInstance]
                                                   getAuthKey] toMobileNumber:self.mobileNumberTextField.text completionBlock:^(BOOL result, id responseDict, NSError *error) {
        
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

-(void)proceedWithRegister:(NSString *)
userid password:(NSString *)password firstName:(NSString *)firstname lastName:(NSString *)lastname
{
    [activityView startAnimating];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"DeviceToken"];
    
    void (^registerBlock)(void) = ^{
        WMWebservicesHelper *helper =
        [WMWebservicesHelper sharedInstance];
        NSDictionary* infoDict =
        [[NSBundle mainBundle]infoDictionary];
        NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
        NSMutableDictionary *dataDict =
        [NSMutableDictionary dictionary];
        [dataDict setValue:userid forKey:@"email_id"];
        [dataDict setValue:password forKey:@"password"];
              [dataDict setValue:firstname forKey:@"first_name"];
              [dataDict setValue:lastname forKey:@"last_name"];
//                [dataDict setValue:self.profilePicURL forKey:@"profile_image"];
                [dataDict setValue:[[UIDevice currentDevice] model] forKey:@"device_type"];
                [dataDict setValue:version forKey:@"app_version_ios"];
                [dataDict setValue:deviceToken forKey:@"iphone_device_token"];
                [dataDict setValue:self.mobileNumberTextField.text forKey:@"auditor_ph_no"];
        if (self.facebookid) {
            [dataDict setValue:self.facebookid forKey:@"fb_id"];
        }
        NSString *fcmToken = [FIRMessaging messaging].FCMToken;
        NSLog(@"FCM registration token: %@", fcmToken);
        if (fcmToken) {
            [dataDict setValue:fcmToken forKey:@"gcm_id"];
        }
        [helper registerAuditorWithdata:dataDict imageURL:self.profilePicURL completionBlock:^(BOOL result, id responseDict, NSError *error)
         {
             NSLog(@"result:-> %@",result ? @"success" : @"Failed");
             if (result) {
                 [[WMDataHelper sharedInstance]
                  setAuditorProfileDetails:responseDict];
                 [self sendOTP];
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
    };
    if (deviceToken) {
        registerBlock();
    }else{
        deviceToken = @"gfg6676677vg980vbvvg12ccgvggdgvkfw";
        registerBlock();
    }
}

- (IBAction)signUpBtnTapped:(id)sender {
    
    if (![self isValidEmail:self.emailIdTextField.text]) {
        NSLog(@"Invalid Email Address");
        [self.emailIdTextField showErrorWithText:@"Please type a valid email id"];
    } else if (self.passwordTextField.text.length < 6){
        [self.passwordTextField showErrorWithText:@"Password should be atleast 6 characters long"];
    } else if (self.firstNameTextField.text.length == 0){
        [self.passwordTextField showErrorWithText:@"First name cannot be empty"];
    } else if (self.lastNameTextField.text.length == 0){
        [self.passwordTextField showErrorWithText:@"Last name cannot be empty"];
    } else {
        [self proceedWithRegister:self.emailIdTextField.text password:self.passwordTextField.text firstName:self.firstNameTextField.text lastName:self.lastNameTextField.text];
    }
}

- (IBAction)signInBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITextFieldDelegates
-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:true];
    
    UITouch *touch = [touches anyObject];
    id touchView = touch.view;
    if (touchView == self.profileImgView) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:albumAction];
        [alertController addAction:cameraAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:true completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImgView.image = chosenImage;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imgName = @"temp";
    NSString *imgPath = [paths[0] stringByAppendingPathComponent:imgName];
    
    NSData *data = UIImageJPEGRepresentation(chosenImage, 0.3);
    [data writeToFile:imgPath atomically:true];
    
    // Save it's path
//    self.profilePicURL = imgPath;
//    [self.layer setCornerRadius:30.0f];
//    [self.layer setShadowColor:[UIColor blackColor].CGColor];
//    [self.layer setShadowOpacity:0.8];
//    [self.layer setShadowRadius:3.0];
//    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
