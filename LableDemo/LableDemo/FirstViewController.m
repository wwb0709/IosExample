//
//  FirstViewController.m
//  LableDemo
//
//  Created by wwb on 12-9-3.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController
@synthesize mainTableView;
@synthesize tableArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = @"Lable";
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tableArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *d = [[[NSMutableDictionary alloc] init] autorelease];
    [d setValue:@"1" forKey:@"title"];
    [d setValue:@"2" forKey:@"content"];
    [self.tableArray addObject:d];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];

}

- (void)viewDidUnload
{
//    [self setMainTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [self.tableArray release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self.mainTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark -table delegate


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tag"];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:@"tag"] autorelease];
    }
    //表格设计
    NSDictionary* one = [tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [one objectForKey:@"title"];
    cell.detailTextLabel.text = [one objectForKey:@"content"];
//    id path = [one objectForKey:@"image"];
//    NSURL *url = [NSURL URLWithString:path];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [[UIImage alloc] initWithData:data cache:NO];
//    cell.image=image;
//    [image release];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"test";
}
@end
