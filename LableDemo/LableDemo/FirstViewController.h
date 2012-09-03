//
//  FirstViewController.h
//  LableDemo
//
//  Created by wwb on 12-9-3.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tableArray;

}
@property (nonatomic,retain) NSMutableArray *tableArray;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@end
