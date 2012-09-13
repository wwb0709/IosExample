//
//  ProjectApplication.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "ProjectApplication.h"
#import "Ivan_UITabBar.h"
#import "SHHHomeController.h"
#import "SHHCategoryController.h"
#import "SHHCollectController.h"
#import "SHHSpaceController.h"
#import "SHHSearchController.h"
#import "SHHLoginController.h"

@implementation ProjectApplication

@synthesize mainWindow = mainWindow_;
@synthesize mainViewController = mainViewController_;

+(ProjectApplication *) sharedApplication
{
    return (ProjectApplication *)[UIApplication sharedApplication];
}

- (void)dealloc
{
    [mainViewController_ release];
    [mainWindow_ release];
    [super dealloc];
}

#pragma mark - 模态窗口封装
// 模态窗口封装
- (void) presentModalViewController:(UIViewController *) modalViewController {
	[self presentModalViewController:modalViewController animated:YES singly:YES];
}

// 模态窗口封装
- (void) presentModalViewController:(UIViewController *) modalViewController animated:(BOOL) animated {
	[self presentModalViewController:modalViewController animated:animated singly:YES];
}

// 模态窗口封装
- (void) _presentModalViewControllerWithInfo:(NSDictionary *) info {
	UIViewController *modalViewController = [info objectForKey:@"modalViewController"];
	BOOL animated = [[info objectForKey:@"animated"] boolValue];
    
	[self presentModalViewController:modalViewController animated:animated singly:YES];
}

// 模态窗口封装
- (void) presentModalViewController:(UIViewController *) modalViewController animated:(BOOL) animated singly:(BOOL) singly {
	if (singly && self.modalViewController) {
		[self dismissModalViewControllerAnimated:animated];
		if (animated) {
			NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:modalViewController, @"modalViewController", [NSNumber numberWithBool:animated], @"animated", nil];
			[self performSelector:@selector(_presentModalViewControllerWithInfo:) withObject:info afterDelay:0.5];
			[info release];
			return;
		}
	}
    
	[mainViewController_ presentModalViewController:modalViewController animated:animated];
}


// 取消模态窗口显示
- (void)dismissModalViewControllerAnimated:(BOOL) animated
{
    [mainViewController_ dismissModalViewControllerAnimated:animated];
}

// 获取模态窗口
- (UIViewController *) modalViewController
{
    return mainViewController_.modalViewController;
}

#pragma mark - 操作Tabbar
// 获取TabbarController指针
- (Ivan_UITabBar *) tabBarController
{
    if ([mainViewController_ isKindOfClass:([Ivan_UITabBar class])])
    {
        return (Ivan_UITabBar *) mainViewController_;
    }
    else
    {
        return nil;
    }
}

// 隐藏Tabbar
- (void) hiddenTabBar:(BOOL)hiden
{
    Ivan_UITabBar *tabBar = [self tabBarController];
    
    if (nil != tabBar)
    {
        [tabBar hiddenTabBar:hiden];
    }
}

// 收到登录成功的通知，在发送登录请求的时候，可以在SHHLoginView中添加一个等待视图。
// 这里只是一个简单的demo，点击登录直接发送登录成功通知。
- (void) loginSuccessful:(NSNotification *)notification
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.6f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    UIViewAnimationTransition transition;
    transition = UIViewAnimationTransitionCurlUp;
    
    [UIView setAnimationTransition:transition forView:[[SHHLoginController defaultController].loginViewController view].superview cache:YES];
    
    [[[SHHLoginController defaultController].loginViewController view] removeFromSuperview];
    // 增加Tabbar,如果不需要登录界面，把下面这条代码放到didFinishLaunchingWithOptions中
    [mainWindow_ addSubview:mainViewController_.view];
    [UIView commitAnimations];
}

#pragma mark - 应用程序委托
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 增加消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessful:)
                                                 name:@"LoginSuccessful"
                                               object:nil];
    
    // 显示主界面
    mainWindow_ = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 底部Tabar
    Ivan_UITabBar *tabBarController = [[Ivan_UITabBar alloc] initWithNibName:nil bundle:nil];
    tabBarController.delegate = self;
    
    // 设置Tabar选中的效果图片
    NSMutableDictionary *selectImageDict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    NSString *path = [NSString stringWithFormat:@"recomment_h"];
    NSString *key = [NSString stringWithFormat:@"0"];
    [selectImageDict setObject:path forKey:key];
    NSString *path1 = [NSString stringWithFormat:@"partition_h"];
    NSString *key1 = [NSString stringWithFormat:@"1"];
    [selectImageDict setObject:path1 forKey:key1];
    NSString *path2 = [NSString stringWithFormat:@"space_h"];
    NSString *key2 = [NSString stringWithFormat:@"2"];
    [selectImageDict setObject:path2 forKey:key2];
    NSString *path3 = [NSString stringWithFormat:@"collect_h"];
    NSString *key3 = [NSString stringWithFormat:@"3"];
    [selectImageDict setObject:path3 forKey:key3];
    NSString *path4 = [NSString stringWithFormat:@"search_h"];
    NSString *key4 = [NSString stringWithFormat:@"4"];
    [selectImageDict setObject:path4 forKey:key4];

    tabBarController.dictBtnImg = selectImageDict;
    [selectImageDict release];

    // 设置tabBar对应的viewControllers,此处设置的导航
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:[SHHHomeController defaultController].homeNavigationController, [SHHCategoryController defaultController].categoryNavigationController, [SHHSpaceController defaultController].spaceNavigationController,[SHHCollectController defaultController].collectNavigationController, [SHHSearchController defaultController].searchNavigationController, nil];
    
    tabBarController.viewControllers = viewControllers;
    [viewControllers release];
    
    tabBarController.selectedIndex = 0;
    mainViewController_ = tabBarController;
    
    [mainWindow_ addSubview:[[SHHLoginController defaultController].loginViewController view]];

    [mainWindow_ makeKeyAndVisible];
    
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
