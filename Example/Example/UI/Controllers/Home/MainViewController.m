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
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "SearchCoreManager.h"
#import "ContactPeople.h"
#import "FMDatabase.h"
//#import "ContactPeople.h"
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize dataList,seachResultList,selectedList;
@synthesize searchBar,searchDC;
@synthesize contactDic;
@synthesize searchByName;
@synthesize searchByPhone;
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
    
//    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
//    
//    [SysAddrBookManager loadFromAddrBook:tmpDataArray];
//    self.dataList = [tmpDataArray mutableCopy];
    
    self.dataList  = [[NSMutableDictionary alloc] init];
    [SysAddrBookManager loadFromAddrBook:self.dataList];
    //搜索结果
    self.seachResultList = [[NSMutableDictionary alloc] init];
    
    self.selectedList = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
																					target:self
																					action:@selector(searchBar:)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtnPressed:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self createTableHeader];
    [self createTableFooter];
    
    // 增加消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(choseTableBarSelect:)
                                                 name:@"tabBarSelect"
                                               object:nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    self.contactDic = dic;
    [dic release];
    
    NSMutableArray *nameIDArray = [[NSMutableArray alloc] init];
    self.searchByName = nameIDArray;
    [nameIDArray release];
    NSMutableArray *phoneIDArray = [[NSMutableArray alloc] init];
    
    self.searchByPhone = phoneIDArray;
    [phoneIDArray release];
    
    NSArray * allKeys = [self.dataList allKeys];
    for (int j=0; j<[allKeys count]; j++) {
    VcardPersonEntity * entity=[self.dataList valueForKey:[allKeys objectAtIndex:j]];
        
    ContactPeople *contact = [[ContactPeople alloc] init];
    contact.localID = [NSNumber numberWithInt:[entity.ID intValue]];//[entity.ID ];
        
    NSMutableString *tmpname = [[NSMutableString alloc] init];
    if (entity.NameArr&&[entity.NameArr count]>0) {
        for (int i=0; i<[entity.NameArr count]; i++) {
            NSString *str =[NSString stringWithFormat:@"%@",[entity.NameArr objectForKey:[NSString stringWithFormat:@"%d",i]]];
             if (str!=nil) {
            [tmpname appendString:str];
             }
        }
    }
        
    contact.name = tmpname;
    [tmpname release];
        
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];

     if (entity.PhoneArr&&[entity.PhoneArr count]>0) {
            
        for (int i=0; i<[entity.PhoneArr count]; i++) {
            NSString *str = [[[entity.PhoneArr objectForKey:[NSString stringWithFormat:@"%d",i]] componentsSeparatedByString:@";"] lastObject];
            if (str!=nil) {
                [phoneArray addObject:str];
            }
        }
    }
    contact.phoneArray = phoneArray;
    [phoneArray release];
        
        
    NSLog(@"====%@   ==%@",contact.name,contact.phoneArray);
    [[SearchCoreManager share] AddContact:contact.localID name:contact.name phone:contact.phoneArray];
    [self.contactDic setObject:contact forKey:contact.localID];
    [contact release];
    }
    
    
    //加载在常用
    
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains
//	(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"attribution.db"];
    if (0) {
    
     NSString *path = [[NSBundle mainBundle] pathForResource:@"attribution.db" ofType:nil];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if (![db open]) {
        printLog(@"Could not open db.");
        return;
    }
    
  
    FMResultSet *rs = [db executeQuery:@"select * from changyong"];
   
    while ([rs next]) {
        
      
        // just print out what we've got in a number of formats.
        printLog(@"%@ %@ %@",
                 [rs stringForColumn:@"imgid"],
                 [rs stringForColumn:@"name"],
                 [rs stringForColumn:@"telephone"]);
        
        
        
        ContactPeople *contact = [[ContactPeople alloc] init];
        contact.localID = [NSNumber numberWithInt:[[rs stringForColumn:@"imgid"] intValue]];
        
   
        
        contact.name = [rs stringForColumn:@"name"];
       
        
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        
    
        [phoneArray addObject:[rs stringForColumn:@"telephone"]];
     
        contact.phoneArray = phoneArray;
        [phoneArray release];
        
        
        NSLog(@"====%@   ==%@",contact.name,contact.phoneArray);
        [[SearchCoreManager share] AddContact:contact.localID name:contact.name phone:contact.phoneArray];
        [self.contactDic setObject:contact forKey:contact.localID];
        [contact release];
               
    }
    
    [rs close];
        
    }
    
   
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    
//    //dbPath： 数据库路径，在Document中。
//    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"attribution.db"];
//    
//    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
//    FMDatabase *db= [FMDatabase databaseWithPath:dbPath] ;
//    if (![db open]) {
//        NSLog(@"Could not open db.");
//        return ;
//    }
//    
//    //返回数据库中第一条满足条件的结果
//    //NSString *aa=[db stringForQuery:@"SELECT Name FROM User WHERE Age = ?",@"20"];
//    
//    //返回全部查询结果
//    FMResultSet *rs=[db executeQuery:@"SELECT * FROM changyong"];
//    
//   // rs=[db executeQuery:@"SELECT * FROM User WHERE Age = ?",@"20"];
//    
//    while ([rs next]){
//        NSLog(@"%@ %@ %@",[rs stringForColumn:@"imgid"],[rs stringForColumn:@"name"],[rs stringForColumn:@"telephone"]);
//    }
//    
//    [rs close];
//    NSLog(@"====******");

    

    
    

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

- (void)showDetailViewController:(VcardPersonEntity *) entity
{
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backPreView)];
//     self.navigationItem.leftBarButtonItem = leftButton;
//     self.navigationItem.rightBarButtonItem = nil;
//    self.navigationController.navigationBar.topItem.leftBarButtonItem = leftButton;
//    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
	DetailViewController* viewDetail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    viewDetail.hidesBottomBarWhenPushed = YES;
    viewDetail.delegate = self;
    viewDetail.entity = entity;
    [self.navigationController pushViewController:viewDetail animated:YES];
    return;
    
	self.navigationItem.leftBarButtonItem.target = viewDetail;
   
	CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
	animation.delegate = self;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.type = kCATransitionPush;
	animation.subtype = kCATransitionFromLeft;
	//animation.subtype = kCATransitionFromBottom;
	[[self.view layer] addAnimation:animation forKey:nil];
	[self.view addSubview:viewDetail.view];
//    [[ [[AppDelegate sharedApplication] mainWindow] layer] addAnimation:animation forKey:nil];
//	[[[AppDelegate sharedApplication] mainWindow] addSubview:viewDetail.view];

}

- (void)rightBtnPressed:(id)sender{
    [[AppDelegate sharedApplication] hiddenChoseTabBar:NO];
    //显示多选圆圈
    [self.mainTableView setEditing:YES animated:YES];
    self.navigationItem.leftBarButtonItem.title = @"确定";
    [self.navigationItem.leftBarButtonItem setAction:@selector(rightBtnPressedWithSure:)];
}

- (void)rightBtnPressedWithSure:(id)sender{
    
    
    //do something with selected cells like delete
    NSLog(@"selectedDic------->:%@", self.selectedList);
    NSLog(@"self.dataArray:------>:%@", self.dataList);
    int count = [self.selectedList count];
    if (count > 0 ) {
        
        NSMutableArray * indexPathsArr = [NSMutableArray array];
        for (int i = 0; i<count; i++) {
            NSDictionary *dic = [self.selectedList objectAtIndex:i];
            NSString * pId = [dic valueForKey:@"1"];
            NSIndexPath* indexPath = [dic valueForKey:@"0"];
            NSArray * allkeys = [self.dataList allKeys];
            
            if ([allkeys containsObject:pId]) {
                [indexPathsArr addObject:indexPath];
                [self.dataList removeObjectForKey:pId];
            }
//            [self.dataList removeObjectAtIndex:row];
//            NSLog(@"self.dataArray:------>:%@", self.dataList);
            
        }
        
        

        [self.mainTableView deleteRowsAtIndexPaths:indexPathsArr withRowAnimation:UITableViewRowAnimationFade];
    
        
        //NSLog(@"self.selectedDic--------->:%@", self.selectedList);
        if ([self.selectedList count]>0) {
            [self.selectedList removeAllObjects];
        }
        

    
//        [self.mainTableView reloadData];
        [self createTableFooter];
        self.navigationItem.leftBarButtonItem.title = @"编辑";
        [self.navigationItem.leftBarButtonItem setAction:@selector(rightBtnPressed:)];
        [self.mainTableView setEditing:NO animated:YES];
          [[AppDelegate sharedApplication] hiddenChoseTabBar:YES];
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
                [[AppDelegate sharedApplication] hiddenChoseTabBar:YES];
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
//    [self.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"All",@"Device",@"Desktop",@"Portable",nil]];
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


//choseTablebar回调
-(void)choseTableBarSelect:(NSNotification *)notification
{
    NSLog(@"current select Index:%d",222);

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
        return [self.searchByName count] + [self.searchByPhone count];//[self.seachResultList count];
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
    {
//        NSArray * allKeys = [self.seachResultList allKeys];
//        entity= [self.seachResultList valueForKey:[allKeys objectAtIndex:row]];
//        entity= [self.seachResultList objectAtIndex:row];
        NSNumber *localID = nil;
        NSMutableString *matchString = [NSMutableString string];
        NSMutableArray *matchPos = [NSMutableArray array];
        if (indexPath.row < [searchByName count]) {
            localID = [self.searchByName objectAtIndex:indexPath.row];
            
            //姓名匹配 获取对应匹配的拼音串 及高亮位置
            if ([self.searchBar.text length]) {
                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
            }
        } else {
            localID = [self.searchByPhone objectAtIndex:indexPath.row-[searchByName count]];
            NSMutableArray *matchPhones = [NSMutableArray array];
            
            //号码匹配 获取对应匹配的号码串 及高亮位置
            if ([self.searchBar.text length]) {
                [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                [matchString appendString:[matchPhones objectAtIndex:0]];
            }
        }
        ContactPeople *contact = [self.contactDic objectForKey:localID];
        
        cell.name = contact.name;
        cell.dec = matchString;
        cell.loc = [contact.phoneArray objectAtIndex:0];
        UIImage *image = [UIImage imageNamed:@"background"];
        cell.image = image;//[imageList objectAtIndex:row];
        
        return cell;
    }
    else
    {
        NSArray * allKeys = [self.dataList allKeys];
        entity= [self.dataList valueForKey:[allKeys objectAtIndex:row]];
        cell.name = entity.ID;
        if (entity.PhoneArr&&[entity.PhoneArr count]>0) {
            cell.loc = [[[entity.PhoneArr objectForKey:@"0"] componentsSeparatedByString:@";"] lastObject];
        }
        if ([entity.NameArr count]>1) {
            cell.dec = [NSString stringWithFormat:@"%@%@",[entity.NameArr objectForKey:@"0"],[entity.NameArr objectForKey:@"1"]];//[entity.NameArr objectForKey:@"0"];
        }
        
        //    NSString *imageUrl = [[NSString alloc] initWithFormat:@"index%i.png", 0];
        UIImage *image = [UIImage imageNamed:@"background"];
        cell.image = image;//[imageList objectAtIndex:row];
        return cell;
    }

  
    
}

//添加一项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    return;
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"确定"]) {
        
        VcardPersonEntity * entity= nil;
        if (tableView == self.searchDC.searchResultsTableView)
        {
            NSArray * allKeys = [self.seachResultList allKeys];
            entity= [self.seachResultList valueForKey:[allKeys objectAtIndex:[indexPath row]]];
        }
        else
        {
//            entity= [self.dataList objectAtIndex:[indexPath row]];
            NSArray * allKeys = [self.dataList allKeys];
            entity= [self.dataList valueForKey:[allKeys objectAtIndex:[indexPath row]]];
        }
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setValue:indexPath forKey:@"0"];
        [dict setValue:entity.ID forKey:@"1"];
        [self.selectedList addObject:dict];
        [dict release];
//        NSLog(@"Select---->:%@",self.selectedList);
    }
    else
    {
        VcardPersonEntity * entity= nil;
        if (tableView == self.searchDC.searchResultsTableView)
        {
            NSArray * allKeys = [self.seachResultList allKeys];
            entity= [self.seachResultList valueForKey:[allKeys objectAtIndex:[indexPath row]]];
        }
        else
        {
            //            entity= [self.dataList objectAtIndex:[indexPath row]];
            NSArray * allKeys = [self.dataList allKeys];
            entity= [self.dataList valueForKey:[allKeys objectAtIndex:[indexPath row]]];
        }
        [self showDetailViewController:entity];
    
    }
}
//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didDeselectRowAtIndexPath");
     return;
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"确定"]) {
        VcardPersonEntity * entity= nil;
        if (tableView == self.searchDC.searchResultsTableView)
        {
            NSArray * allKeys = [self.seachResultList allKeys];
            entity= [self.seachResultList valueForKey:[allKeys objectAtIndex:[indexPath row]]];
        }
        else
        {
//            entity= [self.dataList objectAtIndex:[indexPath row]];
            NSArray * allKeys = [self.dataList allKeys];
            entity= [self.dataList valueForKey:[allKeys objectAtIndex:[indexPath row]]];
        }
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setValue:indexPath forKey:@"0"];
        [dict setValue:entity.ID forKey:@"1"];
        [self.selectedList removeObject:dict];
        [dict release];

//        [self.selectedList removeObject:indexPath];
//        NSLog(@"Deselect---->:%@",self.selectedList);
    }
}
#pragma mark -
#pragma mark cell 编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了编辑");
//    NSUInteger row = [indexPath row];
//    [self.dataList removeObjectAtIndex:row];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                     withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self createTableFooter];
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSLog(@"手指撮动了");
        //return UITableViewCellEditingStyleDelete;
//    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"编辑"])
//        return UITableViewCellEditingStyleDelete;
//    else
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
    
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:searchByName phoneMatch:self.searchByPhone];
    
     [self.mainTableView reloadData];
    
//    NSArray * allkeys = [self.dataList allKeys];
//	for (NSString *personID in allkeys)
//	{
//        VcardPersonEntity * entity  = [self.dataList valueForKey:personID];
//        //		if ([scope isEqualToString:@"All"] || [product.type isEqualToString:scope])
//        if ([scope isEqualToString:@"All"])
//		{
//			NSComparisonResult result = [entity.ID compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
//            if (result == NSOrderedSame)
//			{
//				[self.seachResultList setValue:entity forKey:entity.ID];
//            }
//		}
//	}
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
