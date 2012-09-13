//
//  SHHSpaceController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHHSpaceNavigationController;

@interface SHHSpaceController : NSObject
{
    SHHSpaceNavigationController *spaceNavigationController_;
}

+ (SHHSpaceController *) defaultController;

@property (nonatomic, retain) SHHSpaceNavigationController *spaceNavigationController;

@end
