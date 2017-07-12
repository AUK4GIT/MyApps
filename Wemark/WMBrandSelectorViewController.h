//
//  WMBrandSelectorViewController.h
//  Wemark
//
//  Created by Kiran Reddy on 03/06/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol WMBrandSelectionProtocol <NSObject>
- (void)didSelectBrand:(id)locationobj;
@end
@interface WMBrandSelectorViewController : BaseViewController
@property (nonatomic, weak) id<WMBrandSelectionProtocol> delegate;
@property (nonatomic, strong) NSArray *brandsArray;
@end
