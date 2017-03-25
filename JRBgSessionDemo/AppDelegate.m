//
//  AppDelegate.m
//  JRBgSessionDemo
//
//  Created by sky on 2017/3/24.
//  Copyright © 2017年 sky. All rights reserved.
//

#import "AppDelegate.h"
#import "DownloadViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[DownloadViewController alloc] init];
    
    
    [self.window makeKeyAndVisible];
    
    // 询问用户是否允许发送通知
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            NSLog(@"允许发送通知");
        } else {
            NSLog(@"不允许发送通知");
        }
        
    }];
    
    
    return YES;
}

#warning 模拟器不调用该方法
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{

    NSLog(@"%s", __func__);
    
    // 存储起来
    self.handler = completionHandler;
}


@end
