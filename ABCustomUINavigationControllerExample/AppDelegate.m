//
//  AppDelegate.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "FlipSquaresNavigationController.h"
#import "CubeNavigationController.h"
#import "PixelateNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[ViewController alloc] initViewController];
    
//    self.window.rootViewController = [[CubeNavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = [[FlipSquaresNavigationController alloc] initWithRootViewController:self.viewController];
//    self.window.rootViewController = [[PixelateNavigationController alloc] initWithRootViewController:self.viewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }

- (void)applicationDidEnterBackground:(UIApplication *)application { }

- (void)applicationWillEnterForeground:(UIApplication *)application { }

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application { }

@end
