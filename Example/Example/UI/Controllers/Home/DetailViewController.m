//
//  DetailViewController.m
//  Example
//
//  Created by wangwb on 13-1-11.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize dataList;
@synthesize delegate,entity;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataList =[[NSMutableArray alloc] init];
//        [dataList addObject:@"1"];
//        [dataList addObject:@"2"];
//        [dataList addObject:@"3"];
//        [dataList addObject:@"4"];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.frontTableView.backgroundColor = [UIColor clearColor];
    self.backScrollView.backgroundColor = [UIColor clearColor];
    
//    [self updateBackgroundFrame];
//    [self updateForegroundFrame];
    [self updateContentOffset];
    
    
    _ID.text = entity.ID;
    
    if ([entity.NameArr count]>1) {
         _pname.text = [NSString stringWithFormat:@"%@%@",[entity.NameArr objectForKey:@"0"],[entity.NameArr objectForKey:@"1"]];//[entity.NameArr objectForKey:@"0"];
    }
//    _pname.text = entity.ID;
//    
//    cell.name = entity.ID;
//    if (entity.PhoneArr&&[entity.PhoneArr count]>0) {
//        cell.loc = [[[entity.PhoneArr objectForKey:@"0"] componentsSeparatedByString:@";"] lastObject];
//    }
//    if ([entity.NameArr count]>1) {
//        cell.dec = [NSString stringWithFormat:@"%@%@",[entity.NameArr objectForKey:@"0"],[entity.NameArr objectForKey:@"1"]];//[entity.NameArr objectForKey:@"0"];
//    }
    for (int i=0; i<[entity.PhoneArr count]; i++) {
        [dataList addObject:[[[entity.PhoneArr objectForKey:[NSString stringWithFormat:@"%d",i]] componentsSeparatedByString:@";"] lastObject]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_backScrollView release];
    [_backImage release];
    [_frontTableView release];
    [entity release];
    delegate = nil;
    [_ID release];
    [_name release];
    [_headimage release];
    [_pname release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBackScrollView:nil];
    [self setBackImage:nil];
    [self setFrontTableView:nil];
    [self setID:nil];
    [self setName:nil];
    [self setHeadimage:nil];
    [self setPname:nil];
    [super viewDidUnload];
}

#pragma mark self method
-(void)backPreView
{
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																					target:self
																					action:@selector(searchBar:)];
	self.delegate.navigationItem.rightBarButtonItem = rightBarButton;
    self.delegate.navigationItem.rightBarButtonItem.target = self.delegate;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnPressed:)];
    self.delegate.navigationItem.leftBarButtonItem = leftButton;
     self.delegate.navigationItem.leftBarButtonItem.target = self.delegate;
    
    CATransition *animation = [CATransition animation];
	animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromRight;
	[[[self.view superview] layer] addAnimation:animation forKey:nil];
	[self.view removeFromSuperview];
    
    
}

#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
        return [self.dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 //in IB I set the identifier to Cell on the TVC in CustomTVC.xib
    static NSString *CustomCellIdentifier = @"resultcontactViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:CustomCellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    NSUInteger row = [indexPath row];
 
    
    cell.textLabel.text =[self.dataList objectAtIndex:row];
    return cell;
    
  
  
    
}

#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateContentOffset];
}


- (void)updateBackgroundFrame {
    self.backScrollView.frame = CGRectMake(0.0f,
                                                 0.0f,
                                                 self.view.frame.size.width,
                                                 self.view.frame.size.height);
    self.backScrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                       self.view.frame.size.height);
    self.backScrollView.contentOffset	= CGPointZero;
    
    self.backScrollView.frame =
    CGRectMake(0.0f,
               floorf((150 - self.backScrollView.frame.size.height)/2),
               self.view.frame.size.width,
               self.backScrollView.frame.size.height);
}

- (void)updateForegroundFrame {
    self.frontTableView.frame = CGRectMake(0.0f,
                                           150,
                                           self.frontTableView.frame.size.width,
                                           self.frontTableView.frame.size.height);
    
    self.frontTableView.frame = self.view.bounds;
    self.frontTableView.contentSize =
    CGSizeMake(self.frontTableView.frame.size.width,
               self.frontTableView.frame.size.height + 150);
}


- (void)updateContentOffset {
    CGFloat offsetY   = self.frontTableView.contentOffset.y;
    CGFloat threshold = self.backScrollView.frame.size.height - self.backImage.frame.size.height;
    
    if (offsetY > -threshold && offsetY < 0.0f) {
        self.backScrollView.contentOffset = CGPointMake(0.0f, floorf(offsetY/2));
    } else if (offsetY < 0.0f) {
        self.backScrollView.contentOffset = CGPointMake(0.0f, offsetY + floorf(threshold/2));
    } else {
        self.backScrollView.contentOffset = CGPointMake(0.0f, offsetY);
    }
}
@end
