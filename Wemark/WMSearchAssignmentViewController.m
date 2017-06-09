//
//  WMSearchAssignmentViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 02/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMSearchAssignmentViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import "ActionSheetPicker.h"
#import "WMIndustrySelectorViewController.h"
#import "WMBrandSelectorViewController.h"
#import "WMSearchResultsViewController.h"

@interface WMSearchAssignmentViewController () <WMBrandSelectionProtocol, WMIndustrySelectionProtocol>
@property(nonatomic, strong) NSArray *industries;
@property(nonatomic, strong) NSArray *clients;
@property(nonatomic, strong) NSArray *fees;
@property(nonatomic, strong) NSArray *reimbursements;
@property (nonatomic, assign) NSInteger numberOfQuestions;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *industryid;
@property (nonatomic, strong) NSString *brandid;
@property (nonatomic, strong) NSString *selectedFees;
@property (nonatomic, strong) NSString *selectedReimbursement;
@property (nonatomic, strong) NSString *selectedNumberOfQuestions;

@property (weak, nonatomic) IBOutlet UICollectionView *priceCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *reimbersementCollectionView;

@end

@implementation WMSearchAssignmentViewController
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
    
    self.title = @"Search Assignments";
    
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    if (authKey.length == 0) {
        return;
    }
    [[WMWebservicesHelper sharedInstance] getAllSearchParametersWithCompletionBlock:^(BOOL result, id responseDict, NSError *error) {
        if (result) {
            self.fees = responseDict[@"feesList"];
            self.reimbursements = responseDict[@"reimbursementAmountList"];
            self.industries = responseDict[@"allIndustries"];
            self.clients = responseDict[@"clients"];
            self.numberOfQuestions = [responseDict[@"maxQuestionCount"] integerValue];
            [self updateUIContent];
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
            [self.priceCollectionView reloadData];
            [self.reimbersementCollectionView reloadData];
        });
    } authkey:authKey];
}

- (void)viewWillLayoutSubviews {
    activityView.center = self.view.center;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.backItem.title = @"";
}

- (void)updateUIContent {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    UISlider *slider = [[cell.contentView viewWithTag:1] viewWithTag:2];
    [slider setMaximumValue:self.numberOfQuestions];
    [slider setMinimumValue:0];
    [slider setValue:0];
    
    UILabel *lbl1 = [[cell.contentView viewWithTag:1] viewWithTag:3];
    UILabel *lbl2 = [[cell.contentView viewWithTag:1] viewWithTag:4];
    UILabel *lbl3 = [[cell.contentView viewWithTag:1] viewWithTag:5];
    
    lbl1.text = @"0";
    lbl2.text = [NSString stringWithFormat:@"%ld",self.numberOfQuestions/2];
    lbl3.text = [NSString stringWithFormat:@"%ld",(long)self.numberOfQuestions];
    self.selectedNumberOfQuestions = @"0";
}

- (IBAction)applyFilter {
    [self performSegueWithIdentifier:@"SearchResults" sender:nil];
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

- (IBAction)showDatePicker :(UIView *)sender {
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:nil maximumDate:nil target:self action:@selector(timeWasSelected:element:) origin:sender];
//    datePicker.minuteInterval = 5;
    datePicker.tag = sender.tag;
    [datePicker showActionSheetPicker];
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    UIButton *button = element;
    [button setTitle:[dateFormatter stringFromDate:selectedTime] forState:UIControlStateNormal];
    if (button.tag == 1) {
        self.startDate = selectedTime;
    } else if(button.tag == 2){
        self.endDate = selectedTime;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"IndustrySelector"]) {
        WMIndustrySelectorViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.industriesArray = self.industries;
    } else if ([segue.identifier isEqualToString:@"BrandSelector"]) {
        WMBrandSelectorViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.brandsArray = self.clients;
    } else if([segue.identifier isEqualToString:@"SearchResults"]) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        UISlider *slider = [[cell.contentView viewWithTag:1] viewWithTag:2];
        self.selectedNumberOfQuestions = [NSString stringWithFormat:@"%f",slider.value];
        WMSearchResultsViewController *vc = [segue destinationViewController];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        NSString *startDate;
        NSString *endDate;
        if (self.startDate == nil) {
            startDate = @"";
        } else {
            startDate = [formatter stringFromDate:self.startDate];
        }
        if (self.endDate == nil) {
            endDate = @"";
        } else {
            endDate = [formatter stringFromDate:self.endDate];
        }

        NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
        [mDict setObject:startDate forKey:@"start_date"];
        [mDict setObject:endDate forKey:@"end_date"];
        [mDict setObject:(self.industryid ? self.industryid : @"") forKey:@"industry_id"];
        [mDict setObject:(self.brandid ? self.brandid : @"") forKey:@"client_id"];
        [mDict setObject:(self.selectedFees ? self.selectedFees : @"") forKey:@"fees"];
        [mDict setObject:(self.selectedReimbursement ? self.selectedReimbursement : @"") forKey:@"reimbursement_amount"];
        [mDict setObject:(self.selectedNumberOfQuestions ? self.selectedNumberOfQuestions : @"0") forKey:@"no_of_questions"];
        vc.dict = [NSDictionary dictionaryWithDictionary:mDict];
    }
}


#pragma mark - UITableViewDataSource

//- (NSInteger)tableView:(__unused UITableView *)tableView
// numberOfRowsInSection:(__unused NSInteger)section
//{
//    return 7;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView
                       cellForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, tableView.bounds.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:60.0/255.0 alpha:1.0];
    [headerView addSubview:label];
    label.text = @"Filters";
    return headerView;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 6) {
        [self applyFilter];
    }
}


#pragma mark - WMIndustrySelectorDelegate

-(void)didSelectIndustry:(id)locationobj {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UILabel *lbl = [[cell.contentView viewWithTag:1] viewWithTag:2];
    lbl.text = [locationobj objectForKey:@"industry_name"];
    self.industryid = [[locationobj objectForKey:@"industry_id"] stringValue];
}

#pragma mark - WMBrandSelectorDelegate
- (void)didSelectBrand:(id)locationobj {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UILabel *lbl = [[cell.contentView viewWithTag:1] viewWithTag:2];
    lbl.text = [locationobj objectForKey:@"city"];
    self.brandid = [[locationobj objectForKey:@"client_id"] stringValue];
}

#pragma mark - UICollectionViewDelegate 

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/4 - 20, 50);
}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        self.selectedFees = [self.fees[indexPath.row] objectForKey:@"fees"];
    } else if (collectionView.tag == 2) {
        self.selectedReimbursement = [self.reimbursements[indexPath.row] objectForKey:@"reimbursement_amount"];
    }
//    [self.reimbursements[indexPath.row] objectForKey:@"reimbursement_amount"]
//    [self.fees[indexPath.row] objectForKey:@"fees"]
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1) {
        return self.fees.count;
    } else if (collectionView.tag == 2) {
        return self.reimbursements.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if (collectionView.tag == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceCell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:1];
        lbl.text = [self.fees[indexPath.row] objectForKey:@"fees"];
        
//        NSMutableString *rupee = [NSMutableString stringWithString:@"₹"];
//        for (int i = 0; i<indexPath.row; i++) {
//            [rupee appendString:@"₹"];
//        }
//        
//        UILabel *lbl2 = [cell viewWithTag:2];
//        lbl2.text = rupee;
        
    } else if (collectionView.tag == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReimburseCell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:1];
        lbl.text = [self.reimbursements[indexPath.row] objectForKey:@"reimbursement_amount"];
        
//        NSMutableString *rupee = [NSMutableString stringWithString:@"₹"];
//        for (int i = 0; i<indexPath.row; i++) {
//            [rupee appendString:@"₹"];
//        }
//        
//        UILabel *lbl2 = [cell viewWithTag:2];
//        lbl2.text = rupee;
    }
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    cell.selectedBackgroundView = bgView;
    return cell;
}

@end
