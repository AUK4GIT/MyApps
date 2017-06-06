//
//  AppDelegate.m
//  Wemark
//
//  Created by Kiran Reddy on 23/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "WMMenuViewController.h"
@import GoogleMaps;
@import GooglePlaces;
//#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:@"AIzaSyDfbkwrGrRZ-cmqs7UChplJSRVn7zrovrc"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDfbkwrGrRZ-cmqs7UChplJSRVn7zrovrc"];
    
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back-button-image"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back-button-image"]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTranslucent:false];
    [[UINavigationBar appearance] setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0]]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *defaults = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:19.0f],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               };
    NSMutableDictionary *resultingAttrs = [NSMutableDictionary dictionaryWithDictionary:defaults];
    [[UINavigationBar appearance] setTitleTextAttributes:resultingAttrs];
    [[UINavigationBar appearance] setShadowImage:[self imageFromColor:[UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0]]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:220/255.0 green:0.0 blue:60/255.0 alpha:1.0]];
    
    return YES;
}

- (void)initializeNotificationServices {
    UIUserNotificationSettings *userNotif = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotif];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)loadhomeScreenWithSidemenu {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *fvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SideMenuNavController"];
    
       WMMenuViewController *rvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WMMenuViewController"];
    self.swController = [[LGSideMenuController alloc] initWithRootViewController:fvc leftViewController:rvc rightViewController:nil];
//    [fvc.view addGestureRecognizer:self.swController.panGestureRecognizer];
    //    [fvc.view addGestureRecognizer:swController.tapGestureRecognizer];
    self.window.rootViewController = self.swController;
    
    fvc.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back-button-image"];
    fvc.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back-button-image"];
    fvc.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    

}

- (UIImage *)imageFromColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0, 0, 1, 1);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 3.0f, 3.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    
    return image;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Remote Notification Settings
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    // Our API returns token in all uppercase, regardless how it was originally sent.
    // To make the two consistent, I am uppercasing the token string here.
    deviceTokenStr = deviceTokenStr.uppercaseString;
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Wemark"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
