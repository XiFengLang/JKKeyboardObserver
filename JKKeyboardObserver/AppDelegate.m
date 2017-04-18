//
//  AppDelegate.m
//  JKKeyboardObserver
//
//  Created by 蒋鹏 on 16/3/14.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "JKKeyboardManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    KeyboardManager().robotizationEnable = YES;
    KeyboardManager().topSpacingToFirstResponder = 20;
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
