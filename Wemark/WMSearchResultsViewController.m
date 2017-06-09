//
//  WMSearchResultsViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 03/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMSearchResultsViewController.h"
#import "WMAssignCell.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"

@interface WMSearchResultsViewController ()
@property (strong, nonatomic) NSMutableArray *assignmentsArray;
@property (assign, nonatomic) BOOL selfAssign;
@property (assign, nonatomic) BOOL apply;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *assignmentsLabel;
@property (weak, nonatomic) IBOutlet UIButton *assignFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *applyFilterButton;
@property (strong, nonatomic) NSString *locationId;
@end

@implementation WMSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Search result";
    [self.tableView registerNib:[UINib nibWithNibName:@"WMAssignCell" bundle:nil] forCellReuseIdentifier:@"WMAssignCell"];
    self.tableView.rowHeight = 124;
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    [[WMWebservicesHelper sharedInstance] getSearchCampaignAssignments:self.dict forAuthKey:authKey completionBlock:^(BOOL result, id responseDict, NSError *error) {
        if (result) {
            self.assignmentsArray = [NSMutableArray arrayWithArray:responseDict];
        }else{
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"]
                 integerValue] == 409) {
                NSLog(@"Error responseDict:->%@",resDict[@"message"]);
                [self showErrorMessage:resDict[@"message"]];
            }else{
                NSLog(@"Error:->%@",error.localizedDescription);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            [activityView stopAnimating];
            self.assignmentsLabel.text = [NSString stringWithFormat:@"%lu Assignments found in your location ",(unsigned long)self.assignmentsArray.count];
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)assignmentFilterAction:(UIButton *)sender {
    [self.assignFilterButton setSelected:false];
    [self.applyFilterButton setSelected:false];
    [self.assignFilterButton setBackgroundColor:[UIColor whiteColor]];
    [self.applyFilterButton setBackgroundColor:[UIColor whiteColor]];
    sender.selected = !sender.selected;
    if (self.assignFilterButton == sender) {
        self.selfAssign = true;
        self.apply = false;
        [self.assignFilterButton setBackgroundColor:[UIColor colorWithRed:52/255.0 green:0.0 blue:110/255.0 alpha:1.0]];
    } else {
        self.apply = true;
        self.selfAssign = true;
        [self.applyFilterButton setBackgroundColor:[UIColor colorWithRed:27/255.0 green:122.0/255.0 blue:226/255.0 alpha:1.0]];
    }
    if (self.locationId) {
//        [self getAssignmentsByLocationid:self.locationId forSelfAssign:[NSString stringWithFormat:@"%d",self.selfAssign] forApply:[NSString stringWithFormat:@"%d",self.apply]];
    } else {
        //        [self getAssignmentsByLocationid:self.locationId forSelfAssign:[NSString stringWithFormat:@"%d",self.selfAssign] forApply:[NSString stringWithFormat:@"%d",self.apply]];
    }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assignmentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMAssignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMAssignCell"];
    
    id assignObj = self.assignmentsArray[indexPath.row];
    cell.moneyLabel.text = [NSString stringWithFormat:@"₹ %@",[assignObj valueForKey:@"fees"]];
    cell.assignStatus.text = [assignObj valueForKey:@"assignment_status"];
    cell.calData.text = [NSString stringWithFormat:@"%@ - %@",[assignObj valueForKey:@"start_date"],[assignObj valueForKey:@"end_date"]];
//    cell.distanceLabel.text = [assignObj valueForKey:@""];//todo
//    [cell setClientImageWithURL:[assignObj valueForKey:@"logoURL"]];
//    cell.titleLabel.text = [assignObj valueForKey:@"campaigntitle"];
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

@end
