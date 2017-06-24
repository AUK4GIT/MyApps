//
//  WMQuestionaire2.h
//  Wemark
//
//  Created by Ashish on 24/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire2 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *expiryDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *chooseOptionLbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;

@end
