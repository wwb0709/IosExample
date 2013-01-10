//
//  MainViewController.m
//  Example
//
//  Created by wangwb on 13-1-10.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "MainViewController.h"
#import "contactViewCell.h"
#import "SysAddrBookManager.h"
#import "BlockUI.h"
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize dataList,seachResultList,selectedList;
@synthesize searchBar,searchDC;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    
    [SysAddrBookManager loadFromAddrBook:tmpDataArray];
    self.dataList = [tmpDataArray mutableCopy];
    
    
    //搜索结果
    self.seachResultList = [[NSMutableArray alloc] init];
    self.selectedList = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																					target:self
																					action:@selector(searchBar:)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnPressed:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self createTableHeader];
    [self createTableFooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.seachResultList release];
    [self.selectedList release];
    [self.searchDC release];
    [_mainTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMainTableView:nil];
    [super viewDidUnload];
}

#pragma mark user self

- (void)rightBtnPressed:(id)sender{
    //显示多选圆圈
    [self.mainTableView setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem.title = @"确定";
    [self.navigationItem.leftBarButtonItem setAction:@selector(rightBtnPressedWithSure:)];
}

- (void)rightBtnPressedWithSure:(id)sender{
    
    
    //do something with selected cells like delete
    //    NSLog(@"selectedDic------->:%@", self.selectedDic);
    int count = [self.selectedList count];
    if (count > 0 ) {
        for (int i = 0; i < count; i++) {
            NSInteger row = [[self.selectedList objectAtIndex:i] row];
            [self.dataList removeObjectAtIndex:row];
        }
        //    NSLog(@"self.dataArray:------>:%@", self.dataArray);
        [self.mainTableView deleteRowsAtIndexPaths:self.selectedList withRowAnimation:UITableViewRowAnimationFade];
        [self.selectedList removeAllObjects];
        //    NSLog(@"self.selectedDic--------->:%@", self.selectedDic);
        //        [cloMableView reloadData];
        [self createTableFooter];
        self.navigationItem.leftBarButtonItem.title = @"编辑";
        [self.navigationItem.leftBarButtonItem setAction:@selector(rightBtnPressed:)];
        [self.mainTableView setEditing:NO animated:YES];
    }else {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"未选中任何数据!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"重新选择",nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            NSLog(@"%d",buttonIndex);
            if(buttonIndex == 0)
            {
                self.navigationItem.leftBarButtonItem.title = @"编辑";
                [self.navigationItem.leftBarButtonItem setAction:@selector(rightBtnPressed:)];
                [self.mainTableView setEditing:NO animated:YES];
            }
        }];
        
    }
    
    
    
    
}

-(void)searchBar:(id)sender{
	[self.searchDC setActive:YES animated:YES];
}
- (void)initSearchBar
{
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
    [self.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"All",@"Device",@"Desktop",@"Portable",nil]];
	self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
    self.searchBar.delegate = self;
	self.mainTableView.tableHeaderView = self.searchBar;
    
	
	// Create the search display controller
	self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDC.delegate = self;
	self.searchDC.searchResultsDataSource = self;
    //	self.searchDC.searchResultsDelegate = self;
}
// 创建表格底部
- (void) createTableHeader
{
    self.mainTableView.tableFooterView = nil;

    [self initSearchBar];
    
}
- (void) createTableFooter
{
    self.mainTableView.tableFooterView = nil;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mainTableView.bounds.size.width, 40.0f)];
    
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    
    [loadMoreText setCenter:tableFooterView.center];
    
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    
    [loadMoreText setText:[NSString stringWithFormat:@"联系人%d个",[self.dataList count]]];
    
    [tableFooterView addSubview:loadMoreText];
    
    
    
    self.mainTableView.tableFooterView = tableFooterView;
    [tableFooterView release];
    
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
    if (tableView == self.searchDC.searchResultsTableView)
        return [self.seachResultList count];
    else
        return [self.dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in IB I set the identifier to Cell on the TVC in CustomTVC.xib
//    static NSString *CustomCellIdentifier = @"resultcontactViewCell";
//    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                       reuseIdentifier:CustomCellIdentifier] autorelease];
//        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//    }
//    NSUInteger row = [indexPath row];
//    //
//    VcardPersonEntity * entity= [self.dataList objectAtIndex:row];
//    cell.textLabel.text = entity.ID;
//    return cell;
    
    static NSString *CustomCellIdentifier = @"resultcontactViewCell";

   contactViewCell *cell = (contactViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"contactViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }




    NSUInteger row = [indexPath row];

    VcardPersonEntity * entity= nil;
    if (tableView == self.searchDC.searchResultsTableView)
        entity= [self.seachResultList objectAtIndex:row];
    else
        entity= [self.dataList objectAtIndex:row];

    cell.name = entity.ID;
    if (entity.PhoneArr&&[entity.PhoneArr count]>0) {
        cell.loc = [[[entity.PhoneArr objectForKey:@"0"] componentsSeparatedByString:@";"] lastObject];
    }
    if ([entity.NameArr count]>1) {
        cell.dec = [entity.NameArr objectForKey:@"0"];
    }
   
    NSString *imageUrl = [[NSString alloc] initWithFormat:@"index%i.png", 0];
    UIImage *image = [UIImage imageNamed:imageUrl];
    cell.image = image;//[imageList objectAtIndex:row];
    return cell;
    
}

//添加一项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"确定"]) {
        [self.selectedList addObject:indexPath];
        NSLog(@"Select---->:%@",self.selectedList);
    }
}
//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didDeselectRowAtIndexPath");
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"确定"]) {
        [self.selectedList removeObject:indexPath];
        NSLog(@"Deselect---->:%@",self.selectedList);
    }
}
#pragma mark -
#pragma mark cell 编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了编辑");
    NSUInteger row = [indexPath row];
    [self.dataList removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    [self createTableFooter];
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSLog(@"手指撮动了");
        //return UITableViewCellEditingStyleDelete;
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"编辑"])
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma mark -
#pragma mark searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
	//进入搜索后，不能进行点击操作
	//self.isModalStatus = YES;
	
	NSString * searchTerm = [_searchBar text];
    printLog(@"current seach text :%@",searchTerm);
    [self.searchBar resignFirstResponder];
    //	[self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;                     // called when text starts editing
{// return NO to not become first responder
	
    //	self.isSearchStatus = YES;
    //[searchBar setShowsCancelButton:YES animated:YES];
    //[self.contactTableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
    //	self.isSearchStatus = NO;
    //    [searchBar setShowsCancelButton:NO animated:YES];
    //    [searchBar setText:@""];
    //	[searchBar resignFirstResponder];
    //    [self resetSearch];
    //    [self.contactTableView reloadData];
	
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear
{
    //    if (0 == [searchText length])
    //    {
    //        if (preSeachLen>0)
    //        {
    //            self.keysOfSection=		nil;
    //            self.keysOfAllContacts=	nil;
    //            preSeachLen=			0;
    //            [self resetSearch];
    //            [self.contactTableView reloadData];
    //        }
    //        return;
    //    }
    //
    //    //tank:2011.7.5 23：30  会退也要进行搜索
    //    if (nil!=searchText && 0 < [searchText length])
    //    {
    //        NSString * searchTerm = searchText;
    //        [self handleSearchForTerm:searchTerm];
    //    }
    
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.seachResultList removeAllObjects];// First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for ( VcardPersonEntity * entity in dataList)
	{
        //		if ([scope isEqualToString:@"All"] || [product.type isEqualToString:scope])
        if ([scope isEqualToString:@"All"])
		{
			NSComparisonResult result = [entity.ID compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.seachResultList addObject:entity];
            }
		}
	}
}
#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDC.searchBar scopeButtonTitles] objectAtIndex:[self.searchDC.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDC.searchBar text] scope:
	 [[self.searchDC.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
	[self.searchDC.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	/*
	 Hide the search bar
	 */
    //	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
}


@end
