//
//  IDCAppDelegate.m
//  iducation
//
//  Created by pebertli on 14/02/13.
//  Copyright (c) 2013 handverse. All rights reserved.
//

#import "IDCAppDelegate.h"
#import "IDCRootViewController.h"

@implementation IDCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Alloc and init root view controller
    self.rootController = [[IDCRootViewController alloc] initWithNibName:@"IDCRootViewController" bundle:nil];
    //Change root`s position to above status bar (will we hide status bar?)
//    UIView* rootView = self.rootController.view;
//    CGRect frameResult = rootView.frame;
//    frameResult.origin.y+=[UIApplication sharedApplication].statusBarFrame.size.height;
//    rootView.frame = frameResult;
    //root application controller will be our IDCRootController
    self.window.rootViewController = self.rootController;
    
    

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    
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

@end
