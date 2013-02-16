//
//  AppDelegate.m
//  AiHao
//
//  Created by wwb on 12-6-19.
//  Copyright (c) 2012年 szty. All rights reserved.
//

//#import "AppDelegate.h"
//#import "testviewcontroller.h"
//#import "ViewController.h"
//#import <FA/FA.h>
//@implementation AppDelegate
//
//@synthesize window = _window;
//@synthesize tabBarController;
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    ViewController *viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
//    return YES;
//    
//    FIClassA* a = [[FIClassA alloc] init];
//    [a methodA];
//    [a release];
//    UIAlertLable* alert = [[UIAlertLable alloc] init];
//    [alert release];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    
//    // Override point for customization after application launch.
//    testviewcontroller *mainViewController = [[testviewcontroller alloc] init];
//  //    testviewcontroller *settingViewController = [[testviewcontroller alloc]init];
////    
////    //隐藏tabbar所留下的黑边（试着注释后你会知道这个的作用）
////    mainViewController.hidesBottomBarWhenPushed = true;
////    searchViewController.hidesBottomBarWhenPushed = true;
////    myselfViewController.hidesBottomBarWhenPushed = true;
////    settingViewController.hidesBottomBarWhenPushed = true;
//    
//    mainViewController.title = @"首页";
//
////    myselfViewController.title = @"我";
////    settingViewController.title = @"设置";
//    
//    //创建导航
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController ];
//
////    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:myselfViewController];
////    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:settingViewController];
//    
//    //创建数组
//    NSMutableArray *controllers = [[NSMutableArray alloc] init];
//    [controllers addObject:nav];
//
////    [controllers addObject:nav2];
////    [controllers addObject:nav3];
//    
//    
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//
//    [images addObject:[UIImage imageNamed:@"bottomfocus.png"]];
//
////    [images addObject:[UIImage imageNamed:@"bottomfocus.png"]];
////    [images addObject:[UIImage imageNamed:@"bottomfocus.png"]];
//    
//    //创建tabbar
//    tabBarController = [[ CustomTabBar alloc] initWithImageArray:images];
//    tabBarController.viewControllers = controllers;
//    [tabBarController selectedTabWithIndex:0];
//
//    
//    
//    //显示
//    [self.window addSubview:tabBarController.view];
//    [self.window makeKeyAndVisible];
//    
//    return YES;
//}
//- (void)dealloc
//{
//    [tabBarController release];
//}
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    /*
//     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//     */
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    /*
//     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//     */
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    /*
//     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//     */
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    /*
//     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//     */
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    /*
//     Called when the application is about to terminate.
//     Save data if appropriate.
//     See also applicationDidEnterBackground:.
//     */
//}
//
//@end
#import "AppDelegate.h"
#import "Ivan_UITabBar.h"
#import "SHHHomeController.h"
#import "SHHCategoryController.h"
#import "SHHCollectController.h"
#import "SHHSpaceController.h"
#import "SHHSearchController.h"
#import "SHHLoginController.h"
#import "BlockUI.h"
#import "wax.h"


static int giAlarmInterval = 5 * 60;            // 5分钟，闹钟时间间隔
const int kTimerInterval = 1 * 60;              // 1分钟，定时器时间间隔
const int kSysMaxTimePerBgTask = 10 * 600;      // 10分钟，系统为每个后台任务分


@implementation AppDelegate

@synthesize mainWindow = mainWindow_;
@synthesize mainViewController = mainViewController_;
@synthesize choseTabBar;

+(AppDelegate *) sharedApplication
{
    return (AppDelegate *)[UIApplication sharedApplication];
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

    Ivan_UITabBar  *tabBar = [self tabBarController];
    if (nil != tabBar)
    {
        [tabBar hiddenTabBar:hiden];
    }
   
}
// 隐藏Tabbar
- (void) hiddenChoseTabBar:(BOOL)hiden
{
  
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationDelegate:self];
    if (hiden) {
        [choseTabBar setCenter:CGPointMake(choseTabBar.center.x, choseTabBar.center.y+choseTabBar.frame.size.height)];
    }
    else
    {
        [choseTabBar setCenter:CGPointMake(choseTabBar.center.x, choseTabBar.center.y-choseTabBar.frame.size.height)];
    }


    [UIView commitAnimations];
    
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
//    // 增加Tabbar,如果不需要登录界面，把下面这条代码放到didFinishLaunchingWithOptions中
//    [mainWindow_ addSubview:mainViewController_.view];
    [UIView commitAnimations];


    Ivan_UITabBar * tmpViewControllers = (Ivan_UITabBar *)mainViewController_;
    NSArray *viewControllers =  tmpViewControllers.viewControllers;
    UINavigationController* homcontroller = [viewControllers objectAtIndex:0];
    
    // 设置导航栏背景颜色
    if ([homcontroller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [homcontroller.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [homcontroller.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"]];
    }

}
-(void)button
{
    return;
	NSDate* now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	comps = [calendar components:unitFlags fromDate:now];
	int hour = [comps hour];
	int min = [comps minute];
	int sec = [comps second];
	
	NSLog(@"%d,%d,%d",hour,min,sec);
    
	int htime1=16;
	int mtime1=16;
    
	int hs=htime1-hour;
	int ms=mtime1-min;
	NSString *start=[[NSString alloc]init];
	start=@"今天的";
	NSString *over=[[NSString alloc]init];
	over=@"今天的";
	
	if(ms<0)
	{
		ms=ms+60;
		hs=hs-1;
	}
	if(hs<0)
	{
		hs=hs+24;
		hs=hs-1;
		
		
	}
	if (ms<=0&&hs<=0) {
		hs=24;
		ms=0;
		over=@"明天的";
	}
	
	UIAlertView *at=[[UIAlertView alloc] initWithTitle:@"!"
											   message:[NSString stringWithFormat:@"你设置的时间：%@ %i:%i TO %@ %i:%i",start,hour,min,over,htime1,mtime1]
											  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[at show];
	[at release];
	
	
	int hm=(hs*3600)+(ms*60)-sec;
	UILocalNotification *notification=[[UILocalNotification alloc] init];
	if (notification!=nil)
	{
        
		NSDate *now=[NSDate new];
		notification.fireDate=[now addTimeInterval:hm];
		NSLog(@"%d",hm);
		notification.timeZone=[NSTimeZone defaultTimeZone];
		notification.soundName = @"ping.caf";
		//notification.alertBody=@"TIME！";
        notification.alertBody = @"客户端有新的版本，点击到App Store升级。";
        notification.alertAction = @"升级";
		
		notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"你设置的时间是：%i ： %i .",nil),htime1,mtime1];
        
		
		[[UIApplication sharedApplication]   scheduleLocalNotification:notification];
		
		
	}
	[over release];
	[start release];
	
    
    
}

#pragma mark - 应用程序委托
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    //排序
//    NSArray *ar = [NSArray arrayWithObjects:@"2",@"1",@"3",nil];
//    NSMutableArray *array =[NSMutableArray array];
//    [array addObjectsFromArray:ar];
//    //[NSArray arrayWithObjects:@"2",@"1",@"3",nil];
//    
//    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        int i = [obj1 intValue];
//        int j = [obj2 intValue];
//        if (i > j) {
//            return NSOrderedDescending;
//        }
//        if (i < j) {
//            return NSOrderedAscending;
//        }
//        return NSOrderedSame;
//    } ];
//    
//    NSLog(@"array:%@",[array componentsJoinedByString:@","]);
////    字符串比较：
//    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [obj1 compare:obj2];//升序
//        return [obj2 compare:obj1];//降序
//    } ];
    
    if (0) {
//        [self button];
        dispatch_async(dispatch_get_main_queue(), ^{
            UILocalNotification * localNotification = [[UILocalNotification alloc] init];
            if (localNotification) {
                localNotification.fireDate= [[[NSDate alloc] init] dateByAddingTimeInterval:60];
//                localNotification.repeatInterval=kCFCalendarUnitMinute;
                localNotification.timeZone=[NSTimeZone defaultTimeZone];
                
                
                
                NSDate* now = [NSDate date];
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
                comps = [calendar components:unitFlags fromDate:now];
                int hour = [comps hour];
                int min = [comps minute];
                int sec = [comps second];
                
                NSLog(@"%d,%d,%d",hour,min,sec);

                localNotification.alertBody = [NSString stringWithFormat:@"当前时间：%i:%i:%i ",hour,min,sec];
                localNotification.alertAction = @"升级";
                localNotification.soundName = @"";
                localNotification.userInfo = nil;
                [application scheduleLocalNotification:localNotification];
            }
        });
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UILocalNotification * localNotification = [[UILocalNotification alloc] init];
//            if (localNotification) {
//                localNotification.fireDate= [[[NSDate alloc] init] dateByAddingTimeInterval:60*2];
//                //                localNotification.repeatInterval=kCFCalendarUnitMinute;
//                localNotification.timeZone=[NSTimeZone defaultTimeZone];
//                
//                
//                
//                NSDate* now = [NSDate date];
//                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//                NSDateComponents *comps = [[NSDateComponents alloc] init];
//                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//                comps = [calendar components:unitFlags fromDate:now];
//                int hour = [comps hour];
//                int min = [comps minute];
//                int sec = [comps second];
//                
//                NSLog(@"%d,%d,%d",hour,min,sec);
//                
//                localNotification.alertBody = [NSString stringWithFormat:@"当前时间：%i:%i:%i ",hour,min,sec];
//                localNotification.alertAction = @"升级";
//                localNotification.soundName = @"";
//                [application scheduleLocalNotification:localNotification];
//            }
//        });
    }
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    UIViewController *viewController = [[UIViewController alloc] init];
//    viewController.view.backgroundColor = [UIColor grayColor];
//    self.window.rootViewController = viewController;
//    [self.window makeKeyAndVisible];
//    
//    
//    
//    
//    //***************
//    //***************
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [viewController.view addSubview:button];
//    button.frame = CGRectMake(50, 50, 100, 44);
//    [button setTitle:@"alert view" forState:UIControlStateNormal];
//    
//    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:@"ok"
//                                              otherButtonTitles:@"other",nil];
//        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
//            NSLog(@"%d",buttonIndex);
//        }];
//        
//    }];
//    
//    
//    //***************
//    //***************
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [viewController.view addSubview:button2];
//    button2.frame = CGRectMake(170, 50, 100, 44);
//    [button2 setTitle:@"action sheet" forState:UIControlStateNormal];
//    
//    [button2 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"cancel"
//                                             destructiveButtonTitle:nil
//                                                  otherButtonTitles:@"item1",@"item2",nil];
//        [sheet showInView:viewController.view withCompletionHandler:^(NSInteger buttonIndex) {
//            NSLog(@"action:%d",buttonIndex);
//        }];
//        
//        
//    }];
//    
//    
//    //***************
//    //***************
//    UISwitch *swithControl = [[UISwitch alloc] initWithFrame:CGRectMake(50, 10, 0, 0)];
//    [viewController.view addSubview:swithControl];
//    [swithControl handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
//        UISwitch *s = sender;
//        NSLog(@"value:%@",s.isOn?@"on":@"off");
//    }];
//    
//    
//    //***************
//    //***************
//    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 110, 220, 0)];
//    [viewController.view addSubview:slider];
//    [slider handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
//        UISlider *slider = sender;
//        NSLog(@"slider:%f",slider.value);
//    }];
//    
//    
//    
//    //***************
//    //***************
//    NSArray *items = [NSArray arrayWithObjects:@"item1",@"item2",@"item3", nil];
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
//    segment.frame = CGRectMake(50, 150, 220, 44);
//    [viewController.view addSubview:segment];
//    [segment handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
//        UISegmentedControl *segment = sender;
//        NSLog(@"segment change to %d",segment.selectedSegmentIndex);
//    }];
//    
//    
//    
//    
//    //***************
//    //***************
//    
//    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 0, 0)];
//    [viewController.view addSubview:datePicker];
//    [datePicker handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
//        UIDatePicker *picker = sender;
//        NSLog(@"date:%@",picker.date);
//    }];
//    
//    
//    
//    return YES;

    // 增加消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccessful:)
                                                 name:@"LoginSuccessful"
                                               object:nil];
    
    // 显示主界面
    mainWindow_ = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    
    
    
    ////////////////////////////////////////////////////////////////
    if (0) {
   
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
    tabBarController.view.frame = [UIScreen mainScreen].bounds;
    
    mainViewController_ = tabBarController;
   
    
    //,如果不需要登录界面，把下面这条代码放到didFinishLaunchingWithOptions中
    [mainWindow_ addSubview:mainViewController_.view];
    
        
    }
    
    ////////////////////////////////////////////////////////////////
    else
    {
       NSArray *viewControllers = [[NSArray alloc] initWithObjects:[SHHHomeController defaultController].homeNavigationController, [SHHSpaceController defaultController].spaceNavigationController, nil];
    UITabBarController *tabController=[[UITabBarController alloc] init];
    
    tabController.viewControllers=viewControllers;
//    tabController.hidesBottomBarWhenPushed = YES;
    tabController.selectedIndex=0;
    
    tabController.delegate=self;//在AppDelegate.h文件内实现UITabBarControllerDelegate协议
    
    //self.tabBarController=tabController;
    [mainWindow_ addSubview:tabController.view];
       
   
        
        
    //[tabController release];
    
    [viewControllers release];
    
    CGSize wsize = mainWindow_.frame.size;

    int tablebarh = tabController.tabBar.frame.size.height;
 
    choseTabBar =  [[UITabBar alloc] initWithFrame:CGRectMake(0, wsize.height-tablebarh, 320, tablebarh)];
    choseTabBar.delegate = self;
    UITabBarItem *frameTabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"Fee" image:nil tag:0];



    UITabBarItem *frameTabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"Dev" image:nil tag:1];



    NSArray *frameTabBarItemArray = [[NSArray alloc] initWithObjects:frameTabBarItem1,frameTabBarItem2,nil];



    [choseTabBar setItems:frameTabBarItemArray];
        
    [mainWindow_ addSubview:choseTabBar];
    [self hiddenChoseTabBar:YES];
    
    
    
    }
    
    
    //////////////////////////////////////////////////////////////////
 
//    [mainWindow_ addSubview:[[SHHLoginController defaultController].loginViewController view]];
    
    //启动画面
    UIImageView* splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [mainWindow_ addSubview:splashView];

//    splashView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{

//       [UIView setAnimationTransition:UIViewAnimationTransitionNone forView: self.window cache:YES];

//        splashView.frame = CGRectMake(-320,0,320,480);
        splashView.alpha = 0;
    }
    completion:^(BOOL finished){
        [splashView removeFromSuperview];
        [splashView release];
        
    }];

    
    
    
    
    
 

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
    return;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    int i = giAlarmInterval / kTimerInterval;
    while (i > 0)
    {
        DoorsBgTaskBegin();
        [NSThread sleepForTimeInterval:kTimerInterval];
        [self alarmFunc];
        DoorsBgTaskEnd();
        
        i--;
    }
    

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


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
          // open app store link
//        NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", APP_STORE_ID];
//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hao123.com"]];
}



#pragma mark -
#pragma mark 私有方法

// 检查是否支持后台运行，检查结果放在类成员属性中，供其他地方访问
// 本例中没有实际使用
//- (void)checkBackgroundSupported
//{
//    bgExeSupported = NO;
//    
//    UIDevice* device = [UIDevice currentDevice];
//    
//    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
//    {
//        bgExeSupported = device.multitaskingSupported;
//    }
//}

- (void)alarmFunc
{
    giAlarmInterval -= kTimerInterval;
    
    if (giAlarmInterval > 0)
    {
        NSLog(@"%d minutes left!", giAlarmInterval / 60);
    }
    else
    {
        NSLog(@"Alarm!Alarm!Alarm!");
    }
}



#pragma mark -
#pragma mark push相关

// Retrieve the device token


//- (void)atOnceShowPushInfo:(NSDictionary*) info
//{
//    NSDictionary *dict = [info objectForKey:@"aps"];
//    NSString *topic = [info objectForKey:@"topic"];
//    NSString *title = [info objectForKey:@"title"];
//    NSString *url = [info objectForKey:@"url"];
//    
//    NSString *alertTitle = @"";
//    
//    if(title && [title isKindOfClass:[NSString class]])
//        alertTitle = title;
//    
//    
//    
//	if (dict && [dict isKindOfClass:[NSDictionary class]]
//        && topic && [topic isKindOfClass:[NSString class]])
//	{
//		NSString *theInfo = [dict objectForKey:@"alert"];
//		if (theInfo && [theInfo isKindOfClass:[NSString class]])
//		{
//			//printLog(@"pushInfo:%@", theInfo);
//			//if (NO == isPushStart)
//			{
//                if([topic isEqualToString:@"1"])
//                {
//                    //[self.userService checkUpdate];
//                    if(url && [url isKindOfClass:[NSString class]])
//                    {
//                        self.pushUrl = url;
//                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alertTitle
//                                                                            message:theInfo
//                                                                           delegate:self
//                                                                  cancelButtonTitle:nil
//                                                                  otherButtonTitles:NSLocalizedString(@"稍后再说",nil),NSLocalizedString(@"升级",nil),nil];
//                        alertView.tag = KAlertTag_ReceivePush;
//                        [alertView  show];
//                        [alertView  release];
//                    }
//                }
//                else if([topic isEqualToString:@"3"])
//                {
//                    //[self.userService checkUpdate];
//                    if(url && [url isKindOfClass:[NSString class]])
//                    {
//                        self.pushUrl = url;
//                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alertTitle
//                                                                            message:theInfo
//                                                                           delegate:self
//                                                                  cancelButtonTitle:nil
//                                                                  otherButtonTitles:NSLocalizedString(@"稍后再说",nil),NSLocalizedString(@"前往",nil),nil];
//                        alertView.tag = KAlertTag_ReceivePush;
//                        [alertView  show];
//                        [alertView  release];
//                    }
//                }
//                else
//                {
//                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:alertTitle
//                                                                        message:theInfo
//                                                                       delegate:self
//                                                              cancelButtonTitle:nil
//                                                              otherButtonTitles:NSLocalizedString(@"好",nil),nil];
//                    [alertView  show];
//                    [alertView  release];
//                }
//                
//			}
//		}
//        
//	}
//}

//- (void)laterShowPushInfo:(NSDictionary*) info
//{
//    [self performSelectorOnMainThread:@selector(showPushInfo:) withObject:info waitUntilDone:NO];
//}
//
//- (void)showPushInfo:(NSDictionary*) info
//{
//    BOOL    actionSheetIsShow =  NO;
//    
//    for (UIView *subV in [UIApplication sharedApplication].keyWindow.subviews)
//    {
//        if (subV && ([subV isKindOfClass:[UIActionSheet class]]))
//        {
//            actionSheetIsShow=  YES;
//            break;
//        }
//    }
//    
//    if (NO==actionSheetIsShow)
//        [self atOnceShowPushInfo:info];
//    else
//    {
//        printLog(@"laterShowPushInfo");
//        [self performSelector:@selector(laterShowPushInfo:) withObject:info afterDelay:5];
//    }
//    
//}

/*-(void) showNotification:(NSDictionary *)userInfo
 {
 NSDictionary *dict = [userInfo objectForKey:@"aps"];
 if (dict && [dict isKindOfClass:[NSDictionary class]])
 {
 NSString *info = [dict objectForKey:@"alert"];
 if (info && [info isKindOfClass:[NSString class]])
 {
 //printLog(@"pushInfo:%@", info);
 //if (NO == isPushStart)
 {
 //[UIUtility  setNeedEncodeDecode:NO];
 [self showPushInfo:info];
 }
 }
 
 }
 else
 {
 //printLog(@"no 'alert' field!");
 //printLog(@"NSDictionary is: %@", [userInfo description]);
 }
 }*/


//接收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[self showNotification:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [self showPushInfo:userInfo];
    
}
//注册push
- (void) launchNotification: (NSNotification *) notification
{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
}

//注册反馈
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSString *sendToken = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> "]];
    printLog(@"%@",sendToken);
    //告知server 服务器
    //    [userService sendDeviceToken:sendToken];
}



#pragma mark  Tabbar inplementation
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	
	if ([tabBar isEqual:choseTabBar])
	{
		if ([item isEqual:[[tabBar items] objectAtIndex:0]])
		{
            printLog(@"select tableitem 0");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarSelect" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"selectIndex",nil]];
		}
		else if ([item isEqual:[[tabBar items] objectAtIndex:1]])
		{
            printLog(@"select tableitem 1");
             [[NSNotificationCenter defaultCenter] postNotificationName:@"tabBarSelect" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"selectIndex",nil]];
		}
    }
}
@end
