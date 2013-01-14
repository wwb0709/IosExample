//
//  AppDelegate.h
//  AiHao
//
//  Created by wwb on 12-6-19.
//  Copyright (c) 2012年 szty. All rights reserved.
//



#import <UIKit/UIKit.h>
//#import "CustomTabBar.h"
@class Ivan_UITabBar;

//@interface AppDelegate : UIResponder <UIApplicationDelegate>
//
//@property (nonatomic, retain) UIWindow *window;
//@property (nonatomic, retain) CustomTabBar *tabBarController;
//
//@end
@interface AppDelegate : UIApplication <UIApplicationDelegate, UITabBarControllerDelegate,UITabBarDelegate>
{
    // 主视图
//    UIWindow *mainWindow_;
    
    // 根视图控制器
//    UIViewController *mainViewController_;
}

@property (retain, nonatomic) UIWindow *mainWindow;
@property (readonly, nonatomic) UIViewController *mainViewController;
@property (readonly, nonatomic) UIViewController *modalViewController;

@property (retain, nonatomic) UITabBar *choseTabBar;//
#pragma mark - 全局对象
+ (AppDelegate *) sharedApplication;

#pragma mark - 模态窗口封装
// 调用模态窗口
- (void)presentModalViewController:(UIViewController *) modalViewController animated:(BOOL) animated;
- (void)presentModalViewController:(UIViewController *) modalViewController animated:(BOOL) animated singly:(BOOL) singly;

// 取消模态窗口显示
- (void)dismissModalViewControllerAnimated:(BOOL) animated;

#pragma mark - Tabbar操作部分
// 隐藏Tabbar
- (void) hiddenTabBar:(BOOL) hiden;
// 隐藏Tabbar
- (void) hiddenChoseTabBar:(BOOL)hiden;

// 获取TabbarController
- (Ivan_UITabBar *) tabBarController;

// 登录成功的响应函数
- (void) loginSuccessful:(NSNotification *) notification;
@end