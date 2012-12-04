//
//  SHHCollectViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCollectViewController.h"
#import "GTMABAddressBook.h"
#import "SysAddrBook.h"

#import "TestCallViewController.h"
@interface SHHCollectViewController ()

@end


@implementation SHHCollectViewController
@synthesize tableview;
@synthesize itemsArry;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"购物车";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
        

        
    }
    return self;
}
//***************** 1、个人基本信息操作 ******************
- (void)OperBasicInfoWithProperty : (ABPropertyID)propertyId
                         andValue : (NSString*)value
                         inPerson : (GTMABPerson *) tmpPerson
{
    
            [tmpPerson setValue:value forProperty:propertyId];
    
    
}
//***************** 2、电话号码信息操作 ******************
- (void)OperContactNumbersWithKey : (CFStringRef)key
                         andValue : (NSString*)value
                         andIndex : (NSUInteger)index
                     // andOperType : (OperationType)opertype
                         inPerson : (GTMABPerson *) tmpPerson
{
    ABMultiValueRef phones= ABRecordCopyValue([tmpPerson recordRef], kABPersonPhoneProperty);
    GTMABMutableMultiValue * MultiValue = [[[GTMABMutableMultiValue alloc] initWithMultiValue:phones ] autorelease];
    
    if (MultiValue) {
        
//        if (opertype == OperationType_del)
//        {
//            [MultiValue removeValueAndLabelAtIndex:index];
//        }
//        else if(opertype == OperationType_add)
        {
            [MultiValue addValue:value withLabel:key];
        }
//        else if(opertype == OperationType_edit)
//        {
//            [MultiValue replaceValueAtIndex:index withValue:value];
//        }
    }
    [tmpPerson setValue:MultiValue forProperty:kABPersonPhoneProperty];
//    CFRelease(MultiValue);
//    CFRelease(phones);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.itemsArry = [NSMutableDictionary dictionary];
    [self.itemsArry setValue:[TestCallViewController class] forKey:@"来电头像测试"];

    
    UITableView *tmpTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-100)];
    tmpTable.delegate = self;
    tmpTable.dataSource = self;
    
    [self.view addSubview:tmpTable];
    self.tableview = tmpTable;
    [tmpTable release];
    
    
    return;
    
    
    
    
    

    
    
//    GTMABAddressBook*    book_ = [[GTMABAddressBook addressBook:[SysAddrBook getSingleAddressBook]] retain];
//    //新加的联系人
//    GTMABPerson *tperson = [[[GTMABPerson alloc] init] autorelease];
//    
//    [self OperBasicInfoWithProperty:kABPersonNicknameProperty andValue:@"test nikname"  inPerson:tperson];
//    [tperson setImage:[UIImage imageNamed:@"iphone5.png"]];
//
//    //2。号码测试
//    [self OperContactNumbersWithKey:(CFStringRef)@"zidingyi" andValue:@"111111111" andIndex:1  inPerson:tperson];
//    
//  
//    [book_ addRecord:tperson];
//    [book_ save];

}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	int count = [self.itemsArry count];
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger sectionIdx = [indexPath section];
	NSInteger rowIdx = [indexPath row];
    static NSString *CellIdentifier = @"RecommendAppsViewCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    

    NSString * tmpSectionKey = [[self.itemsArry allKeys] objectAtIndex:rowIdx];
    cell.textLabel.text = tmpSectionKey;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	return 70;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	NSInteger sectionIdx = [indexPath section];
//	NSInteger row = [indexPath row];
//	if (0==sectionIdx && 0==row) {
//		return nil;
//	}
//	return indexPath;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	NSInteger rowIdx = [indexPath row];
	NSInteger sectionIdx = [indexPath section];
	
    
	//取消选中状态
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString * Key = [[self.itemsArry allKeys] objectAtIndex:rowIdx];
    
    
    id c = [self.itemsArry objectForKey:Key];
    UIViewController *tmpViewController = [[c alloc]init];
    tmpViewController.title = Key;
    [self.navigationController pushViewController:tmpViewController animated:YES];
    [tmpViewController release];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qipao_gray.png"]]];  //设置背景颜色
}

@end
