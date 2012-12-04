//
//  SHHHomeViewController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface SHHHomeViewController : UIViewController
{
    UINavigationController *nav;
    UIImageView  *frontImageView;
    UIImageView  *backImageView;
    UIView *containerView;
    BOOL  isFlip;
    
    
    
    int tickets;
    int count;
    NSThread* ticketsThreadone;
    NSThread* ticketsThreadtwo;
    NSCondition* ticketsCondition;
}
- (CAGradientLayer *)shadowAsInverse:(CGRect)rect  ;
@end
