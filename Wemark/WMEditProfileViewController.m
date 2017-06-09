//
//  WMEditProfileViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 04/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMEditProfileViewController.h"
#import "AFNetworking.h"

@interface WMEditProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *mobileNoTextField;
- (IBAction)editSaveBtnTapped:(id)sender;

@end

@implementation WMEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}
@end
