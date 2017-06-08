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
#import "WMCampaignDetailsViewController.h"

@interface WMMyAssignmentsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL Applied;
@property (assign, nonatomic) BOOL Assigned;
@property (assign, nonatomic) BOOL Accepted;
@property (weak, nonatomic) IBOutlet UIView *noAssignmentsView;
@property (assign, nonatomic) BOOL Rejected;

@property (strong, nonatomic) NSString *auditorId;
@property (strong, nonatomic) NSMutableArray *assignmentsArray;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end

@implementation WMMyAssignmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Assignments";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAppliedCell" bundle:nil] forCellReuseIdentifier:@"WMAppliedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAssignedCell" bundle:nil] forCellReuseIdentifier:@"WMAssignedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAcceptedCell" bundle:nil] forCellReuseIdentifier:@"WMAcceptedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMRejectedCell" bundle:nil] forCellReuseIdentifier:@"WMRejectedCell"];
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"APPLIED", @"ASSIGNED", @"ACCEPTED",@"REJECTED"]];
    self.segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 54);
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:260/255.0 green:0.0 blue:60.0/255.0 alpha:1];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:0.8]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:1.0 green:247.0/255.0 blue:86.0/255.0 alpha:1];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.tag = 3;
    [self segmentedControlChangedValue:self.segmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark - UITbleView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return 150;
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        return 150;
    }else if (self.segmentedControl.selectedSegmentIndex == 2) {
        return 128;
    }else if (self.segmentedControl.selectedSegmentIndex == 3) {
        return 132;
    }
    return 210;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assignmentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    id assignObj = self.assignmentsArray[indexPath.row];

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WMAppliedCell"];
        WMAppliedCell *applCell = (WMAppliedCell *)cell;
        applCell.moneyLabel.text = [NSString stringWithFormat:@"₹ %@",[assignObj valueForKey:@"campaignbudget"]];
        applCell.applied.text = [assignObj valueForKey:@"status"];
        applCell.calDate.text = [NSString stringWithFormat:@"%@ - %@",[assignObj valueForKey:@"startdate"],[assignObj valueForKey:@"enddate"]];
        //    cell.distanceLabel.text = [assignObj valueForKey:@""];//todo
        [applCell setClientImageWithURL:[assignObj valueForKey:@"logoURL"]];
        applCell.titleLabel.text = [assignObj valueForKey:@"campaigntitle"];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WMAssignedCell"];
//        cell.moneyLabel.text = [NSString stringWithFormat:@"₹ %@",[assignObj valueForKey:@"campaignbudget"]];
//        cell.assignStatus.text = [assignObj valueForKey:@"assignmentstatus"];
//        cell.calData.text = [NSString stringWithFormat:@"%@ - %@",[assignObj valueForKey:@"assignmentduedate"],[assignObj valueForKey:@"assignmentduedate"]];
//        //    cell.distanceLabel.text = [assignObj valueForKey:@""];//todo
//        [cell setClientImageWithURL:[assignObj valueForKey:@"logoURL"]];
//        cell.titleLabel.text = [assignObj valueForKey:@"campaigntitle"];
    }else if (self.segmentedControl.selectedSegmentIndex == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WMAcceptedCell"];
//        cell.moneyLabel.text = [NSString stringWithFormat:@"₹ %@",[assignObj valueForKey:@"campaignbudget"]];
//        cell.assignStatus.text = [assignObj valueForKey:@"assignmentstatus"];
//        cell.calData.text = [NSString stringWithFormat:@"%@ - %@",[assignObj valueForKey:@"assignmentduedate"],[assignObj valueForKey:@"assignmentduedate"]];
//        //    cell.distanceLabel.text = [assignObj valueForKey:@""];//todo
//        [cell setClientImageWithURL:[assignObj valueForKey:@"logoURL"]];
//        cell.titleLabel.text = [assignObj valueForKey:@"campaigntitle"];
    }else if (self.segmentedControl.selectedSegmentIndex == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WMRejectedCell"];
//        cell.moneyLabel.text = [NSString stringWithFormat:@"₹ %@",[assignObj valueForKey:@"campaignbudget"]];
//        cell.assignStatus.text = [assignObj valueForKey:@"assignmentstatus"];
//        cell.calData.text = [NSString stringWithFormat:@"%@ - %@",[assignObj valueForKey:@"assignmentduedate"],[assignObj valueForKey:@"assignmentduedate"]];
//        //    cell.distanceLabel.text = [assignObj valueForKey:@""];//todo
//        [cell setClientImageWithURL:[assignObj valueForKey:@"logoURL"]];
//        cell.titleLabel.text = [assignObj valueForKey:@"campaigntitle"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id assignObj = self.assignmentsArray[indexPath.row];
    WMCampaignDetailsViewController *cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WMCampaignDetailsViewController"];
    cVC.campaignid = [assignObj valueForKey:@"campaignid"];
    cVC.clientid = [assignObj valueForKey:@"clientid"];
    
    [self.navigationController pushViewController:cVC animated:true];
}


@end
