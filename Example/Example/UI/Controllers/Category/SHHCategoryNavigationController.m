//
//  SHHCategoryNavigationController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCategoryNavigationController.h"
#import "SHHCategoryViewController.h"
//#import "ProjectApplication.h"

@implementation SHHCategoryNavigationController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.tabBarItem.title = @"分类列表";
        self.tabBarItem.image = [UIImage imageNamed:@"partition"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (categoryViewController_)
        return;
    
    categoryViewController_ = [[SHHCategoryViewController alloc] init];
    
    [self pushViewController:categoryViewController_ animated:NO];
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
    [categoryViewController_ release];
    [super dealloc];
}

@end
