//
//  SHHHomeNavigationController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHHHomeViewController;
@class MainContactViewController;
@interface SHHHomeNavigationController : UINavigationController <UINavigationControllerDelegate>
{
    MainContactViewController *homeViewController_;
}

@end
