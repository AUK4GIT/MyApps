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
@property (strong, nonatomic) IBOutlet UILabel *transactionIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *calDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray *transactionArray;

@end

@implementation WMTransactionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Transaction History";
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    NSString *auditorId = [[WMDataHelper sharedInstance] getAuditorId];
    [self presentUIFromData];
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
- (void)presentUIFromData {
    
//    "auditor_transaction_id": "5",
//    "transaction_type": "credit",
//    "debit_amount": null,
//    "credit_amount": "266000",
//    "campaign_title": "CampaignOne",
//    "campaign_short_description": null,
//    "start_date": "2017-03-16",
//    "end_date": null,
//    "fees": "8000.00",
//    "client_logo": "5912eb047cee6-Philips-Shield.jpg"
    
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

@end
