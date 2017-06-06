//
//  WMIndustrySelectorViewController.h
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 03/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMIndustrySelectionProtocol <NSObject>
- (void)didSelectIndustry:(id)locationobj;
@end
@interface WMIndustrySelectorViewController : UIViewController
@property (nonatomic, weak) id<WMIndustrySelectionProtocol> delegate;
@property (nonatomic, strong) NSArray *industriesArray;
@end
