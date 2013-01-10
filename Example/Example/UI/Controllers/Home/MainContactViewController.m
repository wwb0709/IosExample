//
//  MainContactViewController.m
//  Example
//
//  Created by wangwb on 13-1-8.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "MainContactViewController.h"
#import "contactViewCell.h"
#import "SysAddrBookManager.h"
#import "BlockUI.h"
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
@interface MainContactViewController ()

@end

@implementation MainContactViewController
@synthesize dataList,seachResultList,selectedList;
@synthesize imageList;
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
    self.title = @"首页";
    self.view.backgroundColor = [UIColor grayColor];
    
    // Do any additional setup after loading the view from its nib.
    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSURL *plistURL = [bundle URLForResource:@"friendsInfo" withExtension:@"plist"];
//    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
//    
//    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
//    NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
//    for (int i=0; i<[dictionary count]; i++) {
//        NSString *key = [[NSString alloc] initWithFormat:@"%i", i+1];
//        NSDictionary *tmpDic = [dictionary objectForKey:key];
//        [tmpDataArray addObject:tmpDic];
//        
//        NSString *imageUrl = [[NSString alloc] initWithFormat:@"index%i.png", i];
//        UIImage *image = [UIImage imageNamed:imageUrl];
//        [tmpImageArray addObject:image];
//    }
    
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];

    [SysAddrBookManager loadFromAddrBook:tmpDataArray];
    self.dataList = [tmpDataArray mutableCopy];

    NSMutableArray *tmpImageArray = [[NSMutableArray alloc] init];
    self.imageList = [tmpImageArray copy];
    
    
    //搜索结果
    self.seachResultList = [[NSMutableArray alloc] init];
    self.selectedList = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																					target:self
																					action:@selector(searchBar:)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnPressed:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
//    self.mainTableView.allowsSelectionDuringEditing = YES;
//    self.mainTableView.delegate = self;
//    self.mainTableView.dataSource = self;
//    self.mainTableView.allowsMultipleSelection = YES;
//    self.mainTableView.allowsSelection = YES;
    
//    [self createTableHeader];
//    [self createTableFooter];

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
//	self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
//	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
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
    
//    
//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mainTableView.bounds.size.width, 40.0f)];
//    
//    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
//    
//    [loadMoreText setCenter:tableHeaderView.center];
//    
//    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
//    
//    [loadMoreText setText:[NSString stringWithFormat:@"联系人%d个",[self.dataList count]]];
//    
//    [tableHeaderView addSubview:loadMoreText];
    
    [self initSearchBar];
    
//    self.mainTableView.tableFooterView = self.searchBar;
    
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


//- (void)initSearchBar
//{
//	// Create a search bar
//	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
//	self.searchBar.tintColor = COOKBOOK_PURPLE_COLOR;
//	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//	self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
//	self.mainTableView.tableHeaderView = self.searchBar;
//	
//	// Create the search display controller
//	self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
//    //	self.searchDC.searchResultsDataSource = self;
//    //	self.searchDC.searchResultsDelegate = self;
//}

#pragma mark UITableViewDataSource
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.seachResultList count];
    else
        return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
//    static NSString *CustomCellIdentifier = @"resultcontactViewCell";
//    
//   contactViewCell *cell = (contactViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
//    if (cell == nil) {
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"contactViewCell" owner:self options:nil];
//        cell = [array objectAtIndex:0];
//        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//    }
//
////    if (tableView == self.searchDisplayController.searchResultsTableView)
////    {
////        
////        
////              
//////        static NSString *CustomCellIdentifier1 = @"resultcontactViewCell";
//////        
//////        static BOOL nibsRegistered1 = NO;
//////        if (!nibsRegistered1) {
//////            UINib *nib = [UINib nibWithNibName:@"contactViewCell" bundle:nil];
//////            [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier1];
//////            nibsRegistered1 = YES;
//////        }
//////        
//////        cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier1];
////    }
////    else
////    {
////        static NSString *CustomCellIdentifier = @"contactViewCell";
////        
////        static BOOL nibsRegistered = NO;
////        if (!nibsRegistered) {
////            UINib *nib = [UINib nibWithNibName:@"contactViewCell" bundle:nil];
////            [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
////            nibsRegistered = YES;
////        }
////    
////        cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
////    }
//    
//    
//    NSUInteger row = [indexPath row];
//    
//    VcardPersonEntity * entity= nil;
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//        entity= [self.seachResultList objectAtIndex:row];
//    else
//        entity= [self.dataList objectAtIndex:row];
//
//    cell.name = entity.ID;
//    if (entity.PhoneArr&&[entity.PhoneArr count]>0) {
//        cell.loc = [[[entity.PhoneArr objectForKey:@"0"] componentsSeparatedByString:@";"] lastObject];
//    }
//    if ([entity.NameArr count]>1) {
//        cell.dec = [entity.NameArr objectForKey:@"0"];
//    }
//   
//    NSString *imageUrl = [[NSString alloc] initWithFormat:@"index%i.png", 0];
//    UIImage *image = [UIImage imageNamed:imageUrl];
//    cell.image = image;//[imageList objectAtIndex:row];
//    
    
    
    NSUInteger row = [indexPath row];
    
    VcardPersonEntity * entity= [self.dataList objectAtIndex:row];

    static NSString *CustomCellIdentifier = @"resultcontactViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CustomCellIdentifier] autorelease];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text = entity.ID;
    return cell;
}

#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}





//header通过下面两个代理方法设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

//footer通过下面两个

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
    UILabel *footlable = [[[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)] autorelease];
    
    
    
    //设置显示文字
    
    footlable.text = [NSString stringWithFormat:@"联系人（%d）个",[self.dataList count]];
    
    
    
    //设置字体:粗体，正常的是 SystemFontOfSize
    
    footlable.font = [UIFont boldSystemFontOfSize:20];
    
    //设置文字颜色
    
    footlable.textColor = [UIColor orangeColor];
    
    
    
    //设置文字位置
    
    
    
    footlable.textAlignment = UITextAlignmentCenter;
    
    //设置字体大小适应label宽度
    
    footlable.adjustsFontSizeToFitWidth = YES;
    
    
    
    //设置label的行数
    
    footlable.numberOfLines = 1;
    
    footlable.backgroundColor=[UIColor clearColor]; //可以去掉背景色
    
    
    
    //设置高亮
    
    footlable.highlighted = YES;
    
    footlable.highlightedTextColor = [UIColor orangeColor];
    
    //设置阴影
    
    footlable.shadowColor = [UIColor redColor];
    
    footlable.shadowOffset = CGSizeMake(1.0,1.0);
    
    //设置是否能与用户进行交互
    
    footlable.userInteractionEnabled = YES;
    
    //设置label中的文字是否可变，默认值是YES
    
    footlable.enabled = NO;
    
    //设置文字过长时的显示格式
    
    footlable.lineBreakMode = UILineBreakModeMiddleTruncation;//截去中间
    
    //  typedef enum {
    
    //      UILineBreakModeWordWrap = 0,
    
    //      UILineBreakModeCharacterWrap,
    
    //      UILineBreakModeClip,//截去多余部分
    
    //      UILineBreakModeHeadTruncation,//截去头部
    
    //      UILineBreakModeTailTruncation,//截去尾部
    
    //      UILineBreakModeMiddleTruncation,//截去中间
    
    //  } UILineBreakMode;
    
    //如果adjustsFontSizeToFitWidth属性设置为YES，这个属性就来控制文本基线的行为
    
    footlable.baselineAdjustment = UIBaselineAdjustmentNone;
    
    //  typedef enum {
    
    //      UIBaselineAdjustmentAlignBaselines,
    
    //      UIBaselineAdjustmentAlignCenters,
    
    //      UIBaselineAdjustmentNone,
    
    //  } UIBaselineAdjustment;
    
    return footlable;
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
//    return UITableViewCellEditingStyleNone;
   
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"编辑";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	/*
	 Hide the search bar
	 */
//	[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
}


@end
