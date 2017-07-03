//
//  WMMenuViewController.m
//  MySideMenu
//
//  Created by Uday Kiran Ailapaka on 16/05/17.
//  Copyright © 2017 Kiran Reddy. All rights reserved.
//

#import "WMMenuViewController.h"
#import "AppDelegate.h"
#import "WMDataHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WMMyAccountViewController.h"

@interface WMMenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *emailAddress;
@end

@implementation WMMenuViewController
{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.profilePic.layer.cornerRadius = self.profilePic.bounds.size.width/2;
//    self.profilePic.layer.borderWidth = 1.0f;
    self.profilePic.layer.masksToBounds = true;
    self.profilePic.clipsToBounds = true;
    self.profilePic.userInteractionEnabled = true;

//    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [self.profilePic addGestureRecognizer:singleTap];
}
    
    - (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        UINavigationController *nvc = (UINavigationController *)appDelegate.swController.rootViewController;
        WMMyAccountViewController *mvc = (WMMyAccountViewController *)nvc.topViewController;
        mvc.navigateToEditProfile = true;
    }

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id auditor = [[WMDataHelper sharedInstance] getAuditor];
    
    self.username.text = [auditor valueForKey:@"username"];
    self.emailAddress.text = [auditor valueForKey:@"usermailid"];
    NSString *profilePicImgURL = [auditor valueForKey:@"profileImageurlstring"];
    [self.profilePic sd_setImageWithURL:[NSURL URLWithString:profilePicImgURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Home";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-home"];

            break;
        case 1:
            cell.textLabel.text = @"Notifications";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-bell"];

            break;
        case 2:
            cell.textLabel.text = @"My Account";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-account"];

            break;
        case 3:
            cell.textLabel.text = @"Assistance";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-assistance"];

            break;
        case 4:
            cell.textLabel.text = @"My Assignments";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-assignment"];
            
            break;
        case 5:
            cell.textLabel.text = @"LogOut";
            cell.imageView.image = [UIImage imageNamed:@"logout"];
            
            break;

        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *nVC = nil;
    switch (indexPath.row) {
        case 0:
        {
            nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SideMenuNavController"];
        }
            break;
        case 1:
        {
            nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsNavigationController"];
        }
            break;
        case 2:
        {
            nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountNavigationController"];
        }
            break;
        case 3:
        {
            nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AssistanceNavigationController"];
        }
            break;
        case 4:
        {
            nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAssignmentsNavigationController"];
        }
            break;
        case 5:
        {
            nVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogOutNavigationController"];
        }
            break;
   
        default:
            break;
    }
    nVC.navigationBar.tintColor = [UIColor whiteColor];
    nVC.navigationBar.barTintColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1.0];
    NSDictionary *defaults = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:19.0f],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               };
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
    nVC.navigationBar.titleTextAttributes = resultingAttrs;

    appDelegate.swController.rootViewController = nVC;
    [appDelegate.swController toggleLeftViewAnimated];
        
}

@end
