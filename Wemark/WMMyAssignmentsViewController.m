//
//  WMMyAssignmentsViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 04/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMMyAssignmentsViewController.h"
#import "HMSegmentedControl.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "WMAppliedCell.h"
#import "WMAssignedCell.h"
#import "WMAcceptedCell.h"
#import "WMRejectedCell.h"

@interface WMMyAssignmentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL Applied;
@property (assign, nonatomic) BOOL Assigned;
@property (assign, nonatomic) BOOL Accepted;
@property (weak, nonatomic) IBOutlet UIView *noAssignmentsView;
@property (assign, nonatomic) BOOL Rejected;

@property (strong, nonatomic) NSString *auditorId;
@property (strong, nonatomic) NSMutableArray *assignmentsArray;

@end

@implementation WMMyAssignmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Assignments";
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"APPLIED", @"ASSIGNED", @"ACCEPTED",@"REJECTED"]];
    segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 54);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.backgroundColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60.0/255.0 alpha:1];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.8]};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:1.0 green:247.0/255.0 blue:86.0/255.0 alpha:1];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.tag = 3;
    [self segmentedControlChangedValue:segmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)appliedTapped:(id)sender {
//    [self performSegueWithIdentifier:@"APPLIED" sender:nil];
//}
//- (void)assignedTapped:(id)sender {
//    [self performSegueWithIdentifier:@"ASSIGNED" sender:nil];
//}
//-(void)acceptedTapped:(id)sender {
//    [self performSegueWithIdentifier:@"ACCEPTED" sender:nil];
//}
//-(void)rejectedTapped:(id)sender {
//    [self performSegueWithIdentifier:@"REJECTED" sender:nil];
//}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    self.Applied = false;
    self.Assigned = false;
    self.Accepted = false;
    self.Rejected = false;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.Applied = true;
    } else if (segmentedControl.selectedSegmentIndex == 1) {
        self.Assigned = true;
    } else if (segmentedControl.selectedSegmentIndex == 2) {
        self.Accepted = true;
    } else if(segmentedControl.selectedSegmentIndex == 3) {
        self.Rejected = true;
    }
    [self getAssignmentsByAuditorid];
}

- (void)getAssignmentsByAuditorid{
    [self hideNoAssignmentsScreen];
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
        NSDictionary *paramsDict = @{@"Applied":[NSNumber numberWithBool:self.Applied],@"Assigned":[NSNumber numberWithBool:self.Assigned],@"Accepted":[NSNumber numberWithBool:self.Accepted],@"Rejected":[NSNumber numberWithBool:self.Rejected]};

    [[WMWebservicesHelper sharedInstance] getAuditorAssignments:authKey paramsDict:paramsDict completionBlock:^(BOOL result, id responseDict, NSError *error) {

        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.assignmentsArray = [NSMutableArray arrayWithArray:[[WMDataHelper sharedInstance] saveAssignments:responseDict]];
        } else {
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"] integerValue] == 409) {
                NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
                [self showNoAssignmentsScreen];
            } else {
                NSLog(@"Error:->  %@",error.localizedDescription);
            }
        }
        //add UI related code here like stopping activity indicator
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [activityView stopAnimating];
//            self.assignmentsLabel.text = [NSString stringWithFormat:@"%d Assignments found in your location ",self.assignmentsArray.count];
            [self.tableView reloadData];
        });
    }];
}

- (void)showNoAssignmentsScreen {
    self.noAssignmentsView.hidden = false;
    [self.view bringSubviewToFront:self.noAssignmentsView];
}

- (void)hideNoAssignmentsScreen {
    self.noAssignmentsView.hidden = true;
    [self.view bringSubviewToFront:self.tableView];
}

- (IBAction)applyNow {
    self.noAssignmentsView.hidden = true;
    [self.view bringSubviewToFront:self.tableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
