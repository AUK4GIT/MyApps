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

@interface WMSignupViewController () <UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet ACFloatingTextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailIdTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *verifyOTPTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImgView;
@property (strong, nonatomic) NSURL *profilePicURL;
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
//                [dataDict setValue:<#(nullable id)#> forKey:@"fb_id"];
        [helper registerAuditorWithdata:dataDict imageURL:self.profilePicURL completionBlock:^(BOOL result, id responseDict, NSError *error)
         {
             NSLog(@"result:-> %@",result ? @"success" : @"Failed");
             if (result) {
                 [[WMDataHelper sharedInstance]
                  setAuditorProfileDetails:responseDict];
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
    self.profilePicURL = info[UIImagePickerControllerReferenceURL];

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
