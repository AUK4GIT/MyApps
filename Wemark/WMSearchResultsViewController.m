//
//  WMSearchResultsViewController.m
//  Wemark
//
//  Created by Kiran Reddy on 03/06/17.
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
    self.tableView.rowHeight = 144;
    [self getAssignmentsforSelfAssign:@"0" forApply:@"0"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAssignmentsforSelfAssign:(NSString *)selfAssign forApply:(NSString *)applyStatus {
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:self.dict];
    [mDict setObject:selfAssign forKey:@"self_assign"];
    [mDict setObject:applyStatus forKey:@"apply"];
    [self showActivity];
    [[WMWebservicesHelper sharedInstance] getSearchCampaignAssignments:mDict forAuthKey:authKey completionBlock:^(BOOL result, id responseDict, NSError *error) {
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
            [self hideActivity];
            self.assignmentsLabel.text = [NSString stringWithFormat:@"%lu Assignments found in your location ",(unsigned long)self.assignmentsArray.count];
            [self.tableView reloadData];
        });
    }];
}

- (IBAction)assignmentFilterAction:(UIButton *)sender {
   
    [sender setSelected:!sender.isSelected];
    if (self.assignFilterButton == sender) {
        self.selfAssign = !self.selfAssign;
    } else {
        self.apply = !self.apply;
    }
    
    [self getAssignmentsforSelfAssign:[NSString stringWithFormat:@"%d",self.selfAssign] forApply:[NSString stringWithFormat:@"%d",self.apply]];
    
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

@end
