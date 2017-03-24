//
//  AppDelegate.h
//  JRBgSessionDemo
//
//  Created by sky on 2017/3/24.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionHandler)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 后台任务完成block */
@property (nonatomic, copy) completionHandler handler;


@end

