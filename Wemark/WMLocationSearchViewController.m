//
//  WMLocationSearchViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 28/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMLocationSearchViewController.h"
#import "WMWebservicesHelper.h"
#import "WMDataHelper.h"


@interface WMLocationSearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *locationsArray;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation WMLocationSearchViewController
{
    NSInteger pageNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Current Location";
    //self.navigationController.navigationBar.backItem.title = @"";


    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Search Location" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0] }];
    self.searchTextField.attributedPlaceholder = str;

    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    pageNumber = 0;
    NSString *authKey = [[WMDataHelper sharedInstance] getAuthKey];
    [[WMWebservicesHelper sharedInstance] getAllLocations:authKey withPageNumber:[NSString stringWithFormat:@"%ld",(long)pageNumber] completionBlock:^(BOOL result, id responseDict, NSError *error) {
        NSLog(@"result:-> %@",result ? @"success" : @"Failed");
        if (result) {
            self.locationsArray = [NSMutableArray arrayWithArray:[[WMDataHelper sharedInstance] saveLocations:responseDict]];
           
        } else {
            NSDictionary *resDict = responseDict;
            if ([resDict[@"code"] integerValue] == 409) {
                NSLog(@"Error responseDict:->  %@",resDict[@"message"]);
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    //self.navigationController.navigationBar.backItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITbleView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor = [UIColor grayColor];
    
    id locObj = self.locationsArray[indexPath.row];
    cell.textLabel.text = [locObj valueForKey:@"city"];
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectLocation:)]) {
        [self.delegate didSelectLocation:self.locationsArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:true];
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
