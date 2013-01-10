//
//  MainContactViewController.h
//  Example
//
//  Created by wangwb on 13-1-8.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainContactViewController : UIViewController<UISearchBarDelegate,
UISearchDisplayDelegate>

@property (retain, nonatomic) IBOutlet UITableView *mainTableView;
@property (retain, nonatomic) NSMutableArray *dataList;
@property (retain, nonatomic) NSArray *imageList;

@property (retain, nonatomic) NSMutableArray *seachResultList;
@property (retain, nonatomic) NSMutableArray *selectedList;



@property (nonatomic, assign) UISearchBar *searchBar;
@property (nonatomic, assign) UISearchDisplayController *searchDC;
@end
