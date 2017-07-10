//
//  WMResetPasswordViewController.m
//  Wemark
//
//  Created by Ashish on 15/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMResetPasswordViewController.h"


@interface WMResetPasswordViewController ()

@end

@implementation WMResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button-image"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
}
- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:true];
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
