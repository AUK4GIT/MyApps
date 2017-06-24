//
//  WMQuestionaire6.h
//  Wemark
//
//  Created by Ashish on 24/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire6 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *addCreditCardLbl;
@property (strong, nonatomic) IBOutlet UILabel *cardHolderNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *expiryDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *cardTypeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *CheckRadioBoxImgV;
@property (strong, nonatomic) IBOutlet UIImageView *unCheckRadioBoxImgV;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;
@end
