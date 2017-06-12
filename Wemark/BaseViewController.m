//
//  BaseViewController.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 10/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    UIActivityIndicatorView * activityView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.tintColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0];

    activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.tintColor = [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0];
    activityView.color = [UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0];
    [activityView setHidesWhenStopped:true];
    [self.view addSubview:activityView];
}

- (void)viewWillLayoutSubviews {
    activityView.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showActivity {
    [self.view bringSubviewToFront:activityView];
    [activityView startAnimating];
}

- (void)hideActivity {
    [activityView stopAnimating];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)convertToString:(id)value {
    if (value == (id)[NSNull null]) {
        return @"";
    } else if ([value isKindOfClass:[NSNumber class]]){
        return [value stringValue];
    } else if ([value isKindOfClass:[NSString class]]){
        return value;
    } else {
        return value;
    }
}


@end
