//
//  WMLocationSearchViewController.h
//  Wemark
//
//  Created by Uday Kiran Ailapaka on 28/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMLocationSearchSelectionProtocol <NSObject>
- (void)didSelectLocation:(id)locationobj;
@end

@interface WMLocationSearchViewController : UIViewController
@property (nonatomic, weak) id<WMLocationSearchSelectionProtocol> delegate;
@end
