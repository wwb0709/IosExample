//
//  SHHCategoryController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHHCategoryNavigationController;

@interface SHHCategoryController : NSObject
{
    SHHCategoryNavigationController *categoryNavigationController_;
}

+ (SHHCategoryController *) defaultController;

@property (nonatomic, retain) SHHCategoryNavigationController *categoryNavigationController;

@end
