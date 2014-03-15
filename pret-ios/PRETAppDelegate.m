//
//  PRETAppDelegate.m
//  PRET
//
//  Created by Gregor on 15.03.2014.
//  Copyright (c) 2014 Wikia Inc. All rights reserved.
//

#import "PRETAppDelegate.h"
#import "PRETHomeViewController.h"
#import "Parse/Parse.h"

@implementation PRETAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Authorize in Parse
    [Parse setApplicationId:@"5bPOC1kbVMfqqw7QbW1SUH1YwZqbkLhbZziuaxmM"
                  clientKey:@"GI9xyrYsM2TaSvQaKBR0glpm2Ym8fNcNhNiVuMXM"];

    // Build Root ViewController
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];

    // Setup NavigationBarController
//    self.navigationBarController = [[PRETNavigationBarController alloc] initWithNavigationController:self.homeViewController];

    // Create window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;

    // Rock & Roll!
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

#pragma mark - Getters
- (PRETHomeViewController *)homeViewController {
    if (_homeViewController == nil) {
        _homeViewController = [[PRETHomeViewController alloc] initWithNibName:nil bundle:nil];

    }

    return _homeViewController;
}

@end