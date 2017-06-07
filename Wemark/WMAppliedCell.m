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
