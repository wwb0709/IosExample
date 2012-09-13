//
//  SHHCollectController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCollectController.h"
#import "SHHCollectNavigationController.h"

@implementation SHHCollectController

@synthesize collectNavigationController = collectNavigationController_;

+ (SHHCollectController *) defaultController
{
    static SHHCollectController *sharedInsctance = nil;
    
    if (nil == sharedInsctance)
    {
        sharedInsctance = [[self alloc] init];
    }
    
    return sharedInsctance;
}

- (id) init
{
    if (!(self = [super init]))
        return nil;
    
    collectNavigationController_ = [[SHHCollectNavigationController alloc] init];
    
    return self;
}

- (void) dealloc
{
    [collectNavigationController_ release];
    [super dealloc];
}

@end
