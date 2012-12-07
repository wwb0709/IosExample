//
//  SHHCollectViewController.h
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^SHHmyblocks) (id object);
@interface SHHCollectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *itemsArry;
    UITableView *tableview;
    UINavigationController *nav;
    
}
@property(nonatomic, copy) SHHmyblocks myblocks;
@property (nonatomic, retain) UITableView *tableview;
@property (nonatomic, retain) NSMutableDictionary *itemsArry;


@end
