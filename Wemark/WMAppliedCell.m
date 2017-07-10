//
//  WMAppliedCell.m
//  Wemark
//
//  Created by Ashish on 07/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMAppliedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WMAppliedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *bgView  = [self.contentView viewWithTag:11];
    bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(1, 1);
    bgView.layer.shadowOpacity = 1.0f;
    bgView.layer.cornerRadius = 3.0f;
}

- (void)layoutSubviews {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setClientImageWithURL:(NSString *)urlString {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlString]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}
@end
