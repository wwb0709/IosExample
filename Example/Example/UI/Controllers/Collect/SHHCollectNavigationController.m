//
//  SHHCollectNavigationController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCollectNavigationController.h"
#import "SHHCollectViewController.h"
//#import "ProjectApplication.h"

@implementation SHHCollectNavigationController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tabBarItem.title = @"购物车";
        self.tabBarItem.image = [UIImage imageNamed:@"collect"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (collectViewController_)
        return;
    
    collectViewController_ = [[SHHCollectViewController alloc] init];
    // 设置导航根视图
   [self pushViewController:collectViewController_ animated:NO];
}

- (void) viewWillAppear:(BOOL)animated
{
    // 设置导航栏背景颜色
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"]];
    }
}

- (void) dealloc
{
    [collectViewController_ release];
    [super dealloc];
}


@end
