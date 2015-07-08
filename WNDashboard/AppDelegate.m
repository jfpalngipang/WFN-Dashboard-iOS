//
//  AppDelegate.m
//  WNDashboard
//
//  Created by Jan Franz Palngipang, iOS App Developer for WiFi Nation on 6/8/15.
//  Copyright (c) 2015 WiFi Nation. All rights reserved.
//  The app uses ios-charts by danielgindi, SWRevealViewController by John-Lluchs and few icons from www.icons8.com
//  Designed by Gerard Reyes, WiFi Nation UX Designer

#import "AppDelegate.h"
#import "FeedsController.h"
#import "requestUtility.h"
#import "AFNetworking.h"
#import <sys/utsname.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
    

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    // Override point for customization after application launch.
    
    // None of the code should even be compiled unless the Base SDK is iOS 8.0 or later
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    // The following line must only run under iOS 8. This runtime check prevents
    // it from running if it doesn't exist (such as running under iOS 7 or earlier).
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        //NSLog(@"PERMISSION!");
    }else{
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#endif

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

    completionHandler(UIBackgroundFetchResultNewData);
    //NSLog(@"BG!");
    FeedsController *feedsController = [[FeedsController alloc] init];
    [feedsController fetchFeedUpdateWithCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
        //NSLog(@"RESULT of FETCH: %lu", (unsigned long)result);
    }];
    application.applicationIconBadgeNumber++;
    //FeedsController *feedsController = (FeedsController *)self.window.rootViewController;
    

    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}



- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken.
    NSLog(@"%@", newDeviceToken);
    struct utsname systemInfo;
    uname(&systemInfo);
    UIDevice *device = [UIDevice currentDevice];
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"MACHINE: %@", machine);
    
    [[NSUserDefaults standardUserDefaults] setObject:newDeviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] setObject:machine forKey:@"machine"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed To Register For Remote Notifications With Error: %@", error);
}
@end
