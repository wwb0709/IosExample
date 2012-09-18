//
//  SHHHomeController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHHHomeNavigationController;

@interface SHHHomeController : NSObject
{
    SHHHomeNavigationController *homeNavigationController_;
}

+ (SHHHomeController *) defaultController;

@property (nonatomic, retain) SHHHomeNavigationController *homeNavigationController;

@end
