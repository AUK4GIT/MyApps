//
//  WMIndustrySelectorViewController.h
//  Wemark
//
//  Created by Kiran Reddy on 03/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol WMIndustrySelectionProtocol <NSObject>
- (void)didSelectIndustry:(id)locationobj;
@end
@interface WMIndustrySelectorViewController : BaseViewController
@property (nonatomic, weak) id<WMIndustrySelectionProtocol> delegate;
@property (nonatomic, strong) NSArray *industriesArray;
@end
