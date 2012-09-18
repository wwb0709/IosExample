//
//  SHHSpaceViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHSpaceViewController.h"
#import "SHHHomeViewController.h"
//#import "ProjectApplication.h"

@implementation SHHSpaceViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"个人空间";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
