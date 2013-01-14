//
//  DetailViewController.h
//  Example
//
//  Created by wangwb on 13-1-11.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "VcardPersonEntity.h"

@interface DetailViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (retain, nonatomic) IBOutlet UIImageView *backImage;
@property (retain, nonatomic) IBOutlet UITableView *frontTableView;
@property (nonatomic, assign) MainViewController *delegate;
@property (retain, nonatomic) NSMutableArray *dataList;
@property (retain, nonatomic) VcardPersonEntity * entity;
@property (retain, nonatomic) IBOutlet UILabel *ID;
@property (retain, nonatomic) IBOutlet UIView *name;
@property (retain, nonatomic) IBOutlet UILabel *pname;
@property (retain, nonatomic) IBOutlet UIImageView *headimage;
-(void)backPreView;
@end
