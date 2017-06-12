//
//  BaseViewController.h
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 10/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (void)showErrorMessage:(NSString *)msg;
- (void)showActivity;
- (void)hideActivity;
- (NSString *)convertToString:(id)value;

@end
