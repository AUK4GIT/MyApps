//
//  BaseFrontViewController.m
//  MySideMenu
//
//  Created by Kiran Reddy on 16/05/17.
//  Copyright © 2017 Kiran Reddy. All rights reserved.
//

#import "BaseFrontViewController.h"
#import "UIViewController+LGSideMenuController.h"

@interface BaseFrontViewController ()

@end
@implementation BaseFrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleTapped:)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)toggleTapped:(id)sender {
    [self toggleLeftViewAnimated:0];
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
