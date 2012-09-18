//
//  SHHSearchController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHSearchController.h"
#import "SHHSearchNavigationController.h"

@implementation SHHSearchController

@synthesize searchNavigationController = searchNavigationController_;

+ (SHHSearchController *) defaultController
{
    static SHHSearchController *sharedInstance = nil;
    
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
    
    searchNavigationController_ = [[SHHSearchNavigationController alloc] init];
    
    return self;
}

- (void) dealloc
{
    [searchNavigationController_ release];
    [super dealloc];
}

@end
