//
//  WMNotificationsViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 04/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMNotificationsViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WMNotificationsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *notificationsArray;
@end

@implementation WMNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Notifications";
    self.tableView.rowHeight = 100;
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    NSString *auditorId = [[WMDataHelper sharedInstance] getAuditorId];

    [[WMWebservicesHelper sharedInstance] getNotifications:authKey byAuditorId:auditorId completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.notificationsArray = [NSArray arrayWithArray:responseDict];
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
    return self.notificationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsCell"];
    cell.textLabel.textColor = [UIColor grayColor];
    
    id locObj = self.notificationsArray[indexPath.row];
    
    UILabel *title = [cell.contentView viewWithTag:2];
    UILabel *time = [cell.contentView viewWithTag:3];
    UILabel *descr = [cell.contentView viewWithTag:4];
    UIImageView *imgView = [cell.contentView viewWithTag:4];

    title.text = [locObj valueForKey:@"notification_title"];
    time.text = [locObj valueForKey:@"timestamp"];
    descr.text = [locObj valueForKey:@"notification_description"];

    [imgView sd_setImageWithURL:[NSURL URLWithString:[locObj valueForKey:@"notification_image"]]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

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
