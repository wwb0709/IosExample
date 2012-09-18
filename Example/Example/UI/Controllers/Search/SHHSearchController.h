//
//  SHHSearchController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHHSearchNavigationController;

@interface SHHSearchController : NSObject
{
    SHHSearchNavigationController *searchNavigationController_;
}

+ (SHHSearchController *) defaultController;

@property (retain, nonatomic) SHHSearchNavigationController *searchNavigationController;

@end
