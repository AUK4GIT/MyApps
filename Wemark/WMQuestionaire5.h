//
//  WMQuestionaire5.h
//  Wemark
//
//  Created by Ashish on 24/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire5 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeOfCreditCardLbl;
@property (strong, nonatomic) IBOutlet UIImageView *checkRadioBoxImgV;
@property (strong, nonatomic) IBOutlet UIImageView *unCheckRadioBoxImgV;
@property (strong, nonatomic) IBOutlet UILabel *addCommentLbl;
@property (strong, nonatomic) IBOutlet UILabel *writeCommentLbl;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;
@end
