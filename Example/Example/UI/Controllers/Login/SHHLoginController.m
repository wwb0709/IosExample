//
//  WallitLoginController.m
//  WallitClient
//
//  Created by huanhuan sui on 12-5-21.
//  Copyright (c) 2012年 Huawei Tec. All rights reserved.
//

#import "SHHLoginController.h"
#import "SHHLoginViewController.h"

@implementation SHHLoginController

@synthesize loginViewController = loginViewController_;

// 登录控制器单实例
+ (SHHLoginController *) defaultController
{
    static SHHLoginController* sharedInstance = nil;
    
    if (nil == sharedInstance)
    {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

- (id) init
{
    if (!(self = [super init]))
        return nil;
    
    loginViewController_ = [[SHHLoginViewController alloc] init];
    
    return self;
}

- (void) dealloc
{
    [loginViewController_ release];
    [super dealloc];
}

@end
