//
//  WMQuestionaire1.h
//  Wemark
//
//  Created by Ashish on 24/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *expiryDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *selectDateLbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;

@end
