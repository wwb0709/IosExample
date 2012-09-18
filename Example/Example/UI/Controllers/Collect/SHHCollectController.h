//
//  SHHCollectController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHHCollectNavigationController;

@interface SHHCollectController : NSObject
{
    SHHCollectNavigationController *collectNavigationController_;
}

+ (SHHCollectController *) defaultController;

@property (nonatomic, retain) SHHCollectNavigationController *collectNavigationController;

@end
