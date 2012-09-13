//
//  SHHSpaceNavigationController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHSpaceNavigationController.h"
#import "SHHSpaceViewController.h"
#import "ProjectApplication.h"

@implementation SHHSpaceNavigationController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tabBarItem.title = @"个人空间";
        self.tabBarItem.image = [UIImage imageNamed:@"space"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if (spaceViewController_)
        return;
    
    spaceViewController_ = [[SHHSpaceViewController alloc] init];
    [self pushViewController:spaceViewController_ animated:NO];
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
    [spaceViewController_  release];
    [super dealloc];
}

@end
