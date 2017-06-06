//
//  WMMenuViewController.m
//  MySideMenu
//
//  Created by Uday Kiran Ailapaka on 16/05/17.
//  Copyright © 2017 Kiran Reddy. All rights reserved.
//

#import "WMMenuViewController.h"
#import "AppDelegate.h"

@interface WMMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WMMenuViewController
{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
    return 5;
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
    
    nVC.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back-button-image"];
    nVC.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back-button-image"];
    nVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

@end
