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
@property (strong, nonatomic) NSArray *notificationsArray;
@end

@implementation WMNotificationsViewController
{
    NSDateFormatter *dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Notifications";

    self.tableView.estimatedRowHeight = 108;
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    NSString *auditorId = [[WMDataHelper sharedInstance] getAuditorId];

    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                              
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
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    id locObj = self.notificationsArray[indexPath.row];
    UIView *bgView = [cell.contentView viewWithTag:1];
    UILabel *title = [bgView viewWithTag:2];
    UILabel *time = [bgView viewWithTag:3];
    UILabel *descr = [bgView viewWithTag:4];
    UIImageView *imgView = [bgView viewWithTag:5];
    imgView.layer.cornerRadius = 40.0;
    title.text = [locObj valueForKey:@"notification_title"];
    descr.text = [locObj valueForKey:@"notification_description"];

    NSDate *givenDate = [dateFormatter dateFromString:[locObj valueForKey:@"timestamp"]];
    if (givenDate) {

//    NSDate *currentDate = [NSDate date];
    // Get the Gregorian calendar
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // Get the date
    NSDate* now = [NSDate date];
    // Get the hours, minutes, seconds
    NSDateComponents *components = [cal components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                            fromDate:givenDate
                                                              toDate:now
                                                             options:0];
        
        if (components.day > 0) {
            time.text = [NSString stringWithFormat:@"%ld days ago",(long)components.day];
        } else if (components.hour > 0) {
            time.text = [NSString stringWithFormat:@"%ld hours ago",(long)components.hour];
        }else if (components.minute > 0 ) {
            time.text = [NSString stringWithFormat:@"%ld mins ago",(long)components.minute];
        }else {
            time.text = [NSString stringWithFormat:@"%ld days ago",(long)components.day];
        }

} else {
    time.text = @"--- --- ago";
    NSLog(@"Date Format Error");
}

    [imgView sd_setImageWithURL:[NSURL URLWithString:[locObj valueForKey:@"notification_image"]]
                    placeholderImage:[UIImage imageNamed:@"notification"]];

    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
