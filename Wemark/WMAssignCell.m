//
//  WMAssignCell.m
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 28/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "WMAssignCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WMAssignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *bgView  = [self.contentView viewWithTag:11];
    bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(1, 1);
    bgView.layer.shadowOpacity = 0.6f;
    bgView.layer.cornerRadius = 3.0f;
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
