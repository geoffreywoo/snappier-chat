//
//  OAppDelegate.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "OAppDelegate.h"
#import "SplashViewController.h"
#import "PufferContentViewController.h"
#import "PufferConnection.h"

#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"

@implementation OAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    
    [UAirship setLogLevel:UALogLevelTrace];
    [UAirship takeOff];
    
    if (username == nil) {
        SplashViewController *rootViewController = [[SplashViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        navigationController.navigationBarHidden = YES;
        self.window.rootViewController = navigationController;
        [UAPush setDefaultPushEnabledValue:NO];
    } else {
        OUser *me = [[OUser alloc] initFromNSDefaults];
        [[PufferConnection sharedInstance] setUser: me];
        
        PufferContentViewController *rootViewController = [[PufferContentViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        navigationController.navigationBarHidden = YES;
        self.window.rootViewController = navigationController;
        [[UAPush shared] setPushEnabled:YES];
        
        if (![defaults boolForKey:@"registeredDeviceToken"]) {
            [UAPush shared].alias = username;
            [[UAPush shared] updateRegistration];
            [defaults setBool:YES forKey:@"registeredDeviceToken"];
        }
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[PufferConnection sharedInstance] getBadgeCountWithCompletionBlock:^(NSError *error, NSDictionary *returnData) {
        if (error)
        {
        }
        else
        {
            NSNumber* count = returnData[@"count"];
            application.applicationIconBadgeNumber = [count integerValue];
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

}

@end
