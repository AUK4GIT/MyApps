//
//  WMTransactionHistoryViewController.m
//  Wemark
//
//  Created by Ashish on 09/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMTransactionHistoryViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface WMTransactionHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *paidAmtImgV;
@property (strong, nonatomic) IBOutlet UIImageView *pendingAmtImgV;
@property (strong, nonatomic) IBOutlet UIImageView *nextPaymentImgV;
@property (strong, nonatomic) IBOutlet UILabel *paidAmtLbl;
@property (strong, nonatomic) IBOutlet UILabel *pendingAmtLbl;
@property (strong, nonatomic) IBOutlet UILabel *nextPaymentLbl;
@property (strong, nonatomic) NSArray *transactionArray;

@end

@implementation WMTransactionHistoryViewController
{
    NSDateFormatter *dateFormatter;
    NSDateFormatter *requiredDateFormatter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Transaction History";
    self.tableView.rowHeight = 200;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    requiredDateFormatter = [[NSDateFormatter alloc] init];
    [requiredDateFormatter setDateFormat:@"dd MMM yyyy"];
    [requiredDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    [[WMWebservicesHelper sharedInstance] getTransactionHistory:authKey completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.transactionArray = [NSArray arrayWithArray:responseDict];
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
            //            [activityView stopAnimating];
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//TransactionsCell
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
    return self.transactionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionsCell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    id locObj = self.transactionArray[indexPath.row];
    UILabel *transactionIdLbl = [[cell.contentView viewWithTag:1] viewWithTag:2];
    UILabel *descrLbl = [cell.contentView viewWithTag:3];
    UILabel *priceLbl = [cell.contentView viewWithTag:4];
    UILabel *dateRangeLbl = [cell.contentView viewWithTag:5];
    UILabel *dateLbl = [cell.contentView viewWithTag:6];
    UIImageView *imgView = [cell.contentView viewWithTag:7];
    
    descrLbl.text = [self convertToString:[locObj valueForKey:@"campaign_short_description"]];
    transactionIdLbl.text = [NSString stringWithFormat:@"Transaction ID: %@",[self convertToString:[locObj valueForKey:@"auditor_transaction_id"]]];
    priceLbl.text = [self convertToString:[locObj valueForKey:@"fees"]];

    NSDate *startDate = [dateFormatter dateFromString:[self convertToString:[locObj valueForKey:@"start_date"]]];
    NSDate *endDate = [dateFormatter dateFromString:[self convertToString:[locObj valueForKey:@"end_date"]]];
    NSString *startDt = @"---";
    NSString *endDt = @"---";
    if (startDate) {
        startDt = [requiredDateFormatter stringFromDate:startDate];
    }
    if (endDate) {
        endDt = [requiredDateFormatter stringFromDate:endDate];
    }
    
    dateRangeLbl.text = [NSString stringWithFormat:@"%@ - %@",startDt,endDt];
    
    dateLbl.text = endDt;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[locObj valueForKey:@"client_logo"]]
               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
   return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end
