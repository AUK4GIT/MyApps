//
//  WMQuestionaire9.h
//  Wemark
//
//  Created by Ashish on 30/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire9 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeOfCreditCardLbl;

@property (strong, nonatomic) IBOutlet UILabel *answerLbl;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;
@end
