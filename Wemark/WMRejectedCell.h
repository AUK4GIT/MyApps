//
//  WMRejectedCell.h
//  Wemark
//
//  Created by Ashish on 07/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMRejectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignStatus;
@property (weak, nonatomic) IBOutlet UILabel *calData;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (void)setClientImageWithURL:(NSString *)urlString;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
