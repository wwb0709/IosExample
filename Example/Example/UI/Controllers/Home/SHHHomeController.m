//
//  SHHHomeController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHHomeController.h"
#import "SHHHomeNavigationController.h"

@implementation SHHHomeController

@synthesize homeNavigationController = homeNavigationController_;

+ (SHHHomeController *) defaultController
{
    static SHHHomeController *sharedInstance = nil;
    
    if (nil == sharedInstance)
    {
        sharedInstance = [[self alloc] init];
    }
    
    return sharedInstance;
}

- (id) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    homeNavigationController_ = [[SHHHomeNavigationController alloc] init];
    
    return self;
}

- (void) dealloc
{
    [homeNavigationController_ release];
    [super dealloc];
}

@end
