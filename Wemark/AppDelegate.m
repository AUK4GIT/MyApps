//
//  AppDelegate.m
//  Wemark
//
//  Created by Kiran Reddy on 23/05/17.
//  Copyright © 2017 Trion Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "WMMenuViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UserNotifications/UserNotifications.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import UIKit;
@import Firebase;
@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()

@end

NSString *const kGCMMessageIDKey = @"gcm.message_id";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [FIRApp configure];
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [GMSServices provideAPIKey:@"AIzaSyDfbkwrGrRZ-cmqs7UChplJSRVn7zrovrc"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDfbkwrGrRZ-cmqs7UChplJSRVn7zrovrc"];
    
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
    [self initializeNotificationServices];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)initializeNotificationServices {
//    UIUserNotificationSettings *userNotif = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeAlert categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:userNotif];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [center requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)loadhomeScreenWithSidemenu {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *fvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SideMenuNavController"];
    
       WMMenuViewController *rvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WMMenuViewController"];
    self.swController = [[LGSideMenuController alloc] initWithRootViewController:fvc leftViewController:rvc rightViewController:nil];
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ self.window.rootViewController = self.swController; }
                    completion:nil];
    
}

- (void)logout {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *fvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginControler"];
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ self.window.rootViewController = fvc; }
                    completion:nil];
}

- (UIImage *)imageFromColor:(UIColor *)color {
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

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
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
