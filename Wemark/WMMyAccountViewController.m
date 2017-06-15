//
//  WMMyAccountViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 04/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMMyAccountViewController.h"
#import "HCSStarRatingView.h"
#import "AppDelegate.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WMEditProfileViewController.h"
#import "WMTransactionHistoryViewController.h"

@interface WMMyAccountViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *profileCompletionLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *completionProgress;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *emailId;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIView *amountBGView;
@property (weak, nonatomic) IBOutlet UIView *assignmentsBGView;
@property (weak, nonatomic) IBOutlet UILabel *amountEarned;
@property (weak, nonatomic) IBOutlet UIView *assignmentsViewOne;
@property (weak, nonatomic) IBOutlet UIView *assignmentsViewTwo;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRatingView;
@property (weak, nonatomic) IBOutlet UIView *assignmentsViewThree;
@property (weak, nonatomic) IBOutlet UILabel *assignmentOneStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *assignmentTwoStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *assignmentThreeStatusLbl;

@property (weak, nonatomic) IBOutlet UILabel *assignmentOneCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *assignmentTwoCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *assignmentThreeCountLbl;

@property (strong, nonatomic) id dataObject;

@end

@implementation WMMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Account";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"editprofile"] style:UIBarButtonItemStylePlain target:self action:@selector(editProfile:)];
    self.assignmentsBGView.layer.cornerRadius = 5.0;
    self.amountBGView.layer.masksToBounds = false;
    self.amountBGView.clipsToBounds = false;
    self.amountBGView.layer.shadowOpacity = 1.0f;
    self.amountBGView.layer.cornerRadius = 5.0;
    self.amountBGView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.amountBGView.layer.shadowOffset = CGSizeMake(2, 2);
    
    self.assignmentsViewOne.layer.cornerRadius = 5.0;
    self.assignmentsViewOne.layer.shadowColor = [UIColor grayColor].CGColor;
    self.assignmentsViewOne.layer.shadowOpacity = 1.0f;
    self.assignmentsViewOne.layer.shadowOffset = CGSizeMake(1, 1);
    
    self.assignmentsViewTwo.layer.cornerRadius = 5.0;
    self.assignmentsViewTwo.layer.shadowColor = [UIColor grayColor].CGColor;
    self.assignmentsViewTwo.layer.shadowOpacity = 1.0f;
    self.assignmentsViewTwo.layer.shadowOffset = CGSizeMake(1, 1);
    
    self.assignmentsViewThree.layer.cornerRadius = 5.0;
    self.assignmentsViewThree.layer.shadowColor = [UIColor grayColor].CGColor;
    self.assignmentsViewThree.layer.shadowOpacity = 1.0f;
    self.assignmentsViewThree.layer.shadowOffset = CGSizeMake(1, 1);
    
    self.profilePic.layer.cornerRadius = self.profilePic.bounds.size.width/2;
    self.profilePic.layer.borderWidth = 4.0f;
    self.profilePic.layer.masksToBounds = true;
    self.profilePic.clipsToBounds = true;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] getAuditorProfileforauthKey:authKey completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.dataObject = responseDict;
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
            if (self.dataObject) {
                [self presentDatainUI];
            }
            [self.tableView reloadData];
        });
    }];
}

- (void)presentDatainUI {
    
    id userObj = [self.dataObject valueForKey:@"user"];
    id userPersonalObj = [self.dataObject valueForKey:@"auditorPersonalDetails"];
    
    
    int progress = [[self.dataObject valueForKey:@"auditorProgressInPercentage"] intValue];
    [self.completionProgress setProgress:progress/100.0 animated:true];
    NSString *percentile = @"%";
    self.profileCompletionLabel.text = [NSString stringWithFormat:@"Your profile is %d%@ complete",progress,percentile];
    
    NSString *profilePicImgURL = [userObj valueForKey:@"profile_image"];
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:profilePicImgURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.profileName.text = [NSString stringWithFormat:@"%@ %@",[userObj valueForKey:@"auditor_fname"],[userObj valueForKey:@"auditor_lname"]];
    self.emailId.text = [self convertToString:[userObj valueForKey:@"auditor_email"]];
    self.phoneNumber.text = [self convertToString:[userObj valueForKey:@"auditor_ph_no"]];
    self.cityName.text = [self convertToString:[userPersonalObj valueForKey:@"auditor_address_city"]];
    
    self.assignmentOneCountLbl.text = [self convertToString:[self.dataObject valueForKey:@"appliedCount"]];
    self.assignmentTwoCountLbl.text= [self convertToString:[self.dataObject valueForKey:@"acceptedCount"]];
    self.assignmentThreeCountLbl.text = [self convertToString:[self.dataObject valueForKey:@"rejectedCount"]];
    
}

- (void)editProfile:(id)sender {
    
    [self performSegueWithIdentifier:@"EditProfile" sender:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"EditProfile"]) {
         WMEditProfileViewController  *vc = segue.destinationViewController;
         vc.profileDict = self.dataObject;
     } else if ([segue.identifier isEqualToString:@"ChangePassword"]) {
         
     } else if ([segue.identifier isEqualToString:@"TransactionsHistory"]) {
//         WMTransactionHistoryViewController  *vc = segue.destinationViewController;
//         id userPersonalObj = [self.dataObject valueForKey:@"auditorPersonalDetails"];
//         vc.auditorId = [[userPersonalObj valueForKey:@"auditor_id"] stringValue];
     }
 }


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChangePassword"];
    } else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionHistory"];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Logout"];
    }
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"TransactionsHistory" sender:nil];
    }else {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate logout];
    }
}

@end
