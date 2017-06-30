//
//  WMQuestionaire12.h
//  Wemark
//
//  Created by Ashish on 30/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMQuestionaire12 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *typeOfCreditCardLbl;

@property (strong, nonatomic) IBOutlet UILabel *uploadFileLbl;
@property (strong, nonatomic) IBOutlet UIButton *chooseFileBtn;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)backBtnActn:(id)sender;
- (IBAction)nextBtnActn:(id)sender;

@end
