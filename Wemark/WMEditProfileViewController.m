//
//  WMEditProfileViewController.m
//  Wemark
//
//  Created by Kiran Reddy on 04/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMEditProfileViewController.h"
#import "WMWebservicesHelper.h"
#import "AFNetworking.h"
#import "ACFloatingTextField.h"
#import "ActionSheetPicker.h"
#import "WMDataHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WMEditProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet ACFloatingTextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *emailIdTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *mobileNoTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *dobTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *countryTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *stateTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *cityTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *pincodeTextField;
@property (strong, nonatomic) IBOutlet ACFloatingTextField *phoneCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
    @property (weak, nonatomic) IBOutlet UIImageView *camPic;
@property (strong, nonatomic) ActionSheetDatePicker *actionSheetPicker;
@property (strong, nonatomic) NSArray *mobileCodes;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSString *authKey;

@property (strong, nonatomic) NSString *selectedCountryName;
@property (strong, nonatomic) NSString *selectedStateName;
@property (strong, nonatomic) NSString *selectedCityName;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *profilePicURL;

- (IBAction)editSaveBtnTapped:(id)sender;

@end

@implementation WMEditProfileViewController

{
    UIActivityIndicatorView * activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.authKey = [[NSString alloc] initWithString:[[WMDataHelper sharedInstance] getAuthKey]];
    
    self.profilePic.layer.cornerRadius = self.profilePic.bounds.size.width/2;
    self.profilePic.layer.borderWidth = 4.0f;
    self.profilePic.layer.masksToBounds = true;
    self.profilePic.clipsToBounds = true;
    
    self.camPic.layer.cornerRadius = self.camPic.bounds.size.width/2;
    self.camPic.layer.borderWidth = 4.0f;
    self.camPic.layer.masksToBounds = true;
    self.camPic.clipsToBounds = true;

    self.profilePic.layer.borderColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0].CGColor;
    self.camPic.layer.borderColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0].CGColor;

    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapped:)];
    [self.profilePic addGestureRecognizer:tapGes];
    
    [self presentUIFromData];
}

- (void)presentUIFromData {
    
    id userObj = [self.profileDict valueForKey:@"user"];
    id userPersonalObj = [self.profileDict valueForKey:@"auditorPersonalDetails"];
    
    NSString *profilePicImgURL = [userObj valueForKey:@"profile_image"];
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:profilePicImgURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.fullNameTextField.text = [userObj valueForKey:@"auditor_fname"];
    self.lastNameTextField.text = [userObj valueForKey:@"auditor_lname"];
    self.emailIdTextField.text = [self convertToString:[userObj valueForKey:@"auditor_email"]];
    self.mobileNoTextField.text = [self convertToString:[userObj valueForKey:@"auditor_ph_no"]];
    if (userPersonalObj != [NSNull null]) {
    self.cityTextField.text = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_city"]];
    self.selectedCityName = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_city"]];
    
    self.countryTextField.text = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_country"]];
    self.selectedCountryName = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_country"]];
    
    self.stateTextField.text = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_state"]];
    self.selectedStateName = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_state"]];
        if ([userPersonalObj valueForKey:@"auditor_dob"] != [NSNull null]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.selectedDate = [self convertToString:[userPersonalObj valueForKey:@"auditor_dob"]];
            NSDate *dob = [dateFormatter dateFromString:self.selectedDate];
            [dateFormatter setDateFormat:@"dd MMM yyyy"];
            self.dobTextField.text = [dateFormatter stringFromDate:dob];
            self.pincodeTextField.text = [self convertToString:[userPersonalObj valueForKey:@"auditor_postal_address_pincode"]];
        }
    }
}

- (void)profilePicTapped:(id)gesture {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeImage];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:albumAction];
    [alertController addAction:removeAction];
    [alertController addAction:cancelAction];

    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}
- (void)removeImage {
    self.profilePic.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showActivity {
    [self.view bringSubviewToFront:activityView];
    [activityView startAnimating];
}

- (void)hideActivity {
    [activityView stopAnimating];
}

- (void)selectADateofBirth:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:[minimumDateComponents year]-18];
    NSDate *maxDate = [calendar dateFromComponents:minimumDateComponents];
    
    [minimumDateComponents setYear:1900];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    
    NSDate *curentDate = maxDate;
    if (self.selectedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        curentDate = [dateFormatter dateFromString:self.selectedDate];
    }
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:curentDate
        target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
//    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

-(void)dateWasSelected:(NSDate *)selectedTime element:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
        self.dobTextField.text = [dateFormatter stringFromDate:selectedTime];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.selectedDate = [dateFormatter stringFromDate:selectedTime];
}


- (void)showListPickerWithList:(NSArray *)listArray andTitle:(NSString *)title textField:(UITextField *)txtField{
    
    [ActionSheetStringPicker showPickerWithTitle:title rows:listArray initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"Picker: %@, Index: %ld, value: %@",picker, (long)selectedIndex, selectedValue);
        txtField.text = selectedValue;
        if (txtField == self.countryTextField) {
        self.selectedCountryName = [self.countries[selectedIndex] valueForKey:@"country_name"];
        } else if (txtField == self.stateTextField){
        self.selectedStateName = [self.states[selectedIndex] valueForKey:@"state_name"];
        }  else if (txtField == self.cityTextField){
        self.selectedCityName = [self.cities[selectedIndex] valueForKey:@"city_name"];
        }
        }
        cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
            }
        origin:txtField];
}

- (IBAction)editSaveBtnTapped:(id)sender {
    if (![self isValidEmail:self.emailIdTextField.text]) {
        NSLog(@"Invalid Email Address");
        [self.emailIdTextField showErrorWithText:@"Please type a valid email id"];
    }  else if (self.fullNameTextField.text.length == 0){
        [self.fullNameTextField showErrorWithText:@"First name cannot be empty"];
    } else if (self.lastNameTextField.text.length == 0){
        [self.lastNameTextField showErrorWithText:@"Last name cannot be empty"];
    } else {
        [self updateProfile];
    }
}

- (void)updateProfile {
    
    NSDictionary *paramsDict = @{@"auditor_fname": self.fullNameTextField.text,
                                 @"auditor_lname": self.lastNameTextField.text,
                                 @"auditor_email": self.emailIdTextField.text,
                                 @"auditor_phone_number_mobile": self.mobileNoTextField.text,
                                 @"auditor_dob": self.selectedDate,
                                 @"auditor_address_country": self.selectedCountryName,
                                 @"auditor_address_state": self.selectedStateName,
                                 @"auditor_address_city": self.selectedCityName,
                                 @"auditor_postal_address_pincode": self.pincodeTextField.text,
                                 @"id": [[WMDataHelper sharedInstance] getAuditorId]};

    [self showActivity];
    [[WMWebservicesHelper sharedInstance] editProfile:self.authKey paramsDict:paramsDict profilePicURL:self.profilePicURL userId:[[WMDataHelper sharedInstance] getAuditorId] completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
//            self.profileDict = responseDict;
            [self showSuccessMessage:@"Profile updated successfully"];
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:true];
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

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profilePic.image = chosenImage;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imgName = @"temp";
    NSString *imgPath = [paths[0] stringByAppendingPathComponent:imgName];
    
    NSData *data = UIImageJPEGRepresentation(chosenImage, 0);
    [data writeToFile:imgPath atomically:true];
    
    // Save it's path
    self.profilePicURL = imgPath;

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UITextField Delegates 

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.countryTextField) {
        if (self.countries == nil || self.countries.count == 0) {
            [self getCountriesAndPresentListPicker];
        } else {
            [self showListPickerWithList:[self.countries valueForKeyPath:@"country_name"] andTitle:@"Select a Country" textField:textField];
        }
        return false;
    } else if (textField == self.dobTextField) {
        [self selectADateofBirth:textField];
        return false;
    } else if (textField == self.stateTextField) {
        if (self.states == nil || self.states.count == 1) {
            [self getStatesAndPresentListPicker];
        } else {
            [self showListPickerWithList:[self.states valueForKeyPath:@"state_name"] andTitle:@"Select a State" textField:textField];
        }
        return false;
    } else if (textField == self.dobTextField) {
        [self selectADateofBirth:textField];
        return false;
    } else if (textField == self.cityTextField) {
        if (self.cities == nil || self.cities.count == 2) {
            [self getCitiesAndPresentListPicker];
        } else {
            [self showListPickerWithList:[self.cities valueForKeyPath:@"city_name"] andTitle:@"Select a City" textField:textField];
        }
        return false;
    } else if (textField == self.dobTextField) {
        [self selectADateofBirth:textField];
        return false;
    }
    return true;
}

- (void)getCountriesAndPresentListPicker {
    [self showActivity];

    [[WMWebservicesHelper sharedInstance] getCountries:self.authKey completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.countries = responseDict;
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
            if (self.countries) {
                [self showListPickerWithList:[self.countries valueForKeyPath:@"country_name"] andTitle:@"Select a Country" textField:self.countryTextField];
            } else {
                [self showErrorMessage:@"Error fetching Countries"];
            }
        });
    }];
}

- (void)getStatesAndPresentListPicker {
    if (self.selectedCountryName == nil) {
        [self showErrorMessage:@"Please select Country first"];
    } else {
        
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] getStates:self.authKey forCountry:self.selectedCountryName completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.states = responseDict;
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
            if (self.states) {
                [self showListPickerWithList:[self.states valueForKeyPath:@"state_name"] andTitle:@"Select a State" textField:self.stateTextField];
            } else {
                [self showErrorMessage:@"Error fetching States"];
            }
        });
    }];
    }
}
- (void)getCitiesAndPresentListPicker {
    
    if (self.selectedStateName == nil) {
        [self showErrorMessage:@"Please select State first"];
    } else {
    
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] getCities:self.authKey forState:self.selectedStateName completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.cities = responseDict;
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
            if (self.cities) {
                [self showListPickerWithList:[self.cities valueForKeyPath:@"city_name"] andTitle:@"Select a City" textField:self.cityTextField];
            } else {
                [self showErrorMessage:@"Error fetching Cities"];
            }
        });
    }];
    }
}

@end
