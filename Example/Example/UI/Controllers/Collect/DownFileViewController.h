//
//  DownFileViewController.h
//  Example
//
//  Created by wangwb on 12-12-20.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileTranserHelper.h"
#import "EGORefreshTableHeaderView.h"
@interface DownFileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FileTranserHelperDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
- (IBAction)AddTask:(id)sender;

@end
