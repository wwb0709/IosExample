//
//  SHHCategoryController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCategoryController.h"
#import "SHHCategoryNavigationController.h"

@implementation SHHCategoryController

@synthesize categoryNavigationController = categoryNavigationController_;

+ (SHHCategoryController *) defaultController
{
    static SHHCategoryController *sharedInstance = nil;
    
    if (nil == sharedInstance)
    {
        sharedInstance = [[self alloc] init];
    }
    
    return  sharedInstance;
}

- (id) init
{
    if (!(self = [super init]))
        return nil;
    
    categoryNavigationController_ = [[SHHCategoryNavigationController alloc] init];
    
    return self;
}

- (void) dealloc
{
    [categoryNavigationController_ release];
    [super dealloc];
}

@end
