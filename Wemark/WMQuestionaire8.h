//
//  WMQuestionaire8.h
//  Wemark
//
//  Created by Ashish on 30/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire8 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *expiryDateOfCreditCardLbl;
@property (strong, nonatomic) IBOutlet UIImageView *dropDownImgV;
@property (strong, nonatomic) IBOutlet UILabel *selectDateLbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;
@end
