//
//  WMLocationSearchViewController.h
//  Wemark
//
//  Created by Kiran Reddy on 28/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol WMLocationSearchSelectionProtocol <NSObject>
- (void)didSelectLocation:(id)locationobj;
@end

@interface WMLocationSearchViewController : BaseViewController
@property (nonatomic, weak) id<WMLocationSearchSelectionProtocol> delegate;
@end
