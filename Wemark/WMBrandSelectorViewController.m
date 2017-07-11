//
//  WMBrandSelectorViewController.m
//  Wemark
//
//  Created by Kiran Reddy on 03/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMBrandSelectorViewController.h"

@interface WMBrandSelectorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WMBrandSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.title = @"Select Brands";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Select Brands";
    //self.navigationController.navigationBar.backItem.title = @"";
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
    return self.brandsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor = [UIColor grayColor];
    
    id locObj = self.brandsArray[indexPath.row];
    cell.textLabel.text = [locObj valueForKey:@"city"];
    return cell;
}

#pragma mark - UITbleView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectBrand:)]) {
        [self.delegate didSelectBrand:self.brandsArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:true];
}
@end
