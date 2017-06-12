//
//  AppDelegate.h
//  Wemark
//
//  Created by Kiran Reddy on 23/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import "Wemark-Swift.h"
#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) LGSideMenuController *swController;

- (void)saveContext;
- (void)loadhomeScreenWithSidemenu;
- (void)logout;
@end

