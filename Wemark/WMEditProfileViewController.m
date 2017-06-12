//
//  WMEditProfileViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 04/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMEditProfileViewController.h"
#import "WMWebservicesHelper.h"
#import "AFNetworking.h"
#import "ACFloatingTextField.h"
#import "ActionSheetPicker.h"

@interface WMEditProfileViewController () <UIImagePickerControllerDelegate>
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
@property (strong, nonatomic) ActionSheetDatePicker *actionSheetPicker;
@property (strong, nonatomic) NSArray *mobileCodes;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSArray *cities;

- (IBAction)editSaveBtnTapped:(id)sender;

@end

@implementation WMEditProfileViewController

{
    UIActivityIndicatorView * activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profilePic.layer.cornerRadius = self.profilePic.bounds.size.width/2;
    self.profilePic.layer.borderWidth = 4.0f;
    self.profilePic.layer.masksToBounds = true;
    self.profilePic.clipsToBounds = true;

    self.profilePic.layer.borderColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0].CGColor;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapped:)];
    [self.profilePic addGestureRecognizer:tapGes];
}
- (void)profilePicTapped:(id)gesture {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:@"Please select a photo source" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];
    
    [self presentViewController:alertController animated:true completion:^{
        
    }];
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

- (void)showErrorMessage:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wemark" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    //    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:true completion:^{
    }];
}

- (void)selectADateofBirth:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1900];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:maxDate
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
}



- (void)showListPickerWithList:(NSArray *)listArray andTitle:(NSString *)title textField:(UITextField *)txtField{
    
    [ActionSheetStringPicker showPickerWithTitle:title
                                            rows:listArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           txtField.text = selectedValue;
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:txtField];
}


/*
 NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http:example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
 [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file:path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
 } error:nil];
 
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 
 NSURLSessionUploadTask *uploadTask;
 uploadTask = [manager
 uploadTaskWithStreamedRequest:request
 progress:^(NSProgress * _Nonnull uploadProgress) {
  This is not called back on the main queue.
  You are responsible for dispatching to the main queue for UI updates
 dispatch_async(dispatch_get_main_queue(), ^{
 Update the progress view
 [progressView setProgress:uploadProgress.fractionCompleted];
 });
 }
 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
 if (error) {
 NSLog(@"Error: %@", error);
 } else {
 NSLog(@"%@ %@", response, responseObject);
 }
 }];
 
 [uploadTask resume];
 
 */


- (IBAction)editSaveBtnTapped:(id)sender {
    if (![self isValidEmail:self.emailIdTextField.text]) {
        NSLog(@"Invalid Email Address");
        [self.emailIdTextField showErrorWithText:@"Please type a valid email id"];
    }  else if (self.fullNameTextField.text.length == 0){
        [self.fullNameTextField showErrorWithText:@"First name cannot be empty"];
    } else if (self.lastNameTextField.text.length == 0){
        [self.lastNameTextField showErrorWithText:@"Last name cannot be empty"];
    } else {
        
    }
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
    NSString *imgURL = info[UIImagePickerControllerReferenceURL];
    self.profilePic.image = chosenImage;
    
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
            [self showListPickerWithList:self.countries andTitle:@"Select a Country" textField:textField];
        }
        return false;
    } else if (textField == self.dobTextField) {
        [self selectADateofBirth:textField];
        return false;
    }
    return true;
    
     if (textField == self.stateTextField) {
        if (self.states == nil || self.states.count == 1) {
            [self getStatesAndPresentListPicker];
        } else {
            [self showListPickerWithList:self.states andTitle:@"Select a State" textField:textField];
        }
        return false;
    } else if (textField == self.dobTextField) {
        [self selectADateofBirth:textField];
        return false;
    }
    return true;
//        [self showListPickerWithList:@[@"1",@"2",@"3"] andTitle:@"Select a Country" textField:textField];
//        return false;
//    } else if (textField == self.dobTextField) {
//        [self selectADateofBirth:textField];
//        return  false;
//    }
//    return true;
    if (textField == self.cityTextField) {
        if (self.cities == nil || self.cities.count == 2) {
            [self getCitiesAndPresentListPicker];
        } else {
            [self showListPickerWithList:self.cities andTitle:@"Select a City" textField:textField];
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
    [[WMWebservicesHelper sharedInstance] getCountries:@"Replace this code with ur implementation for get countries" completionBlock:^(BOOL result, id responseDict, NSError *error) {
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
                [self showListPickerWithList:self.countries andTitle:@"Select a Country" textField:self.countryTextField];
            } else {
                [self showErrorMessage:@"Error fetching Countries"];
            }
        });
    }];
}

- (void)getStatesAndPresentListPicker {
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] getStates:@"Replace this code with ur implementation for get states" completionBlock:^(BOOL result, id responseDict, NSError *error) {
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
                [self showListPickerWithList:self.states andTitle:@"Select a State" textField:self.stateTextField];
            } else {
                [self showErrorMessage:@"Error fetching States"];
            }
        });
    }];
}
- (void)getCitiesAndPresentListPicker {
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] getCities:@"Replace this code with ur implementation for get cities" completionBlock:^(BOOL result, id responseDict, NSError *error) {
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
                [self showListPickerWithList:self.cities andTitle:@"Select a City" textField:self.cityTextField];
            } else {
                [self showErrorMessage:@"Error fetching Cities"];
            }
        });
    }];

    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
}

@end
