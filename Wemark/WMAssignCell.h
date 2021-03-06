//
//  WMAssignCell.h
//  Wemark
//
//  Created by Kiran Reddy on 28/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMAssignCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignStatus;
@property (weak, nonatomic) IBOutlet UILabel *calData;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (void)setClientImageWithURL:(NSString *)urlString;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
