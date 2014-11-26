//
//  AppDelegate.m
//  Keto
//
//  Created by Nelson LeDuc on 11/17/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "KTAAppDelegate.h"
#import "KTARootViewController.h"

@implementation KTAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self displayRootViewController];
    
    return YES;
}

#pragma mark - Private Methods

- (void)displayRootViewController
{
    KTARootViewController *containerViewController = [[KTARootViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = containerViewController;
    [self.window makeKeyAndVisible];
}

@end
