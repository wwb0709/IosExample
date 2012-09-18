//
//  WallitLoginController.h
//  WallitClient
//
//  Created by huanhuan sui on 12-5-21.
//  Copyright (c) 2012年 Huawei Tec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SHHLoginViewController;

@interface SHHLoginController : NSObject
{
    SHHLoginViewController *loginViewController_;
}

+ (SHHLoginController *) defaultController;

@property (nonatomic, retain) SHHLoginViewController *loginViewController;

@end
