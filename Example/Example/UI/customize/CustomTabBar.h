//
//  CustomTabBar.h
//  AiHao
//
//  Created by wwb on 12-6-21.
//  Copyright (c) 2012年 szty. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface CustomTabBar : UITabBarController {
    NSMutableArray *buttons;
    int currentSelectedIndex;
    UIImageView *slideBg;
    NSArray *images;
}

@property (nonatomic,assign) int currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,retain) NSArray *images;

- (id)initWithImageArray:(NSArray *)arr;
- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIImageView *)button;
- (void)selectedTabWithIndex:(int)index;
@end
