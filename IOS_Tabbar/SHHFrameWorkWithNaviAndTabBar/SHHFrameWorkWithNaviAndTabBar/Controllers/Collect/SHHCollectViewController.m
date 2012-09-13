//
//  SHHCollectViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCollectViewController.h"

@interface SHHCollectViewController ()

@end

@implementation SHHCollectViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"购物车";
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
