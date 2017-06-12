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
}

- (void)editProfile:(id)sender {
    
    [self performSegueWithIdentifier:@"EditProfile" sender:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    } else if (indexPath.row == 1) {
    }else {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate logout];
    }
}

@end
