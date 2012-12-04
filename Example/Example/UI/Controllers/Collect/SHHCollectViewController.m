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
#import "InputViewController.h"
#import "ViewController.h"

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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(closeViewEventHandler:)
     name:@"closeView"
     object:nil ];
    
    
    //右按钮
    UIButton *tmpTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpTabBtn setFrame:CGRectMake(0, 0, 55, 37)];
    tmpTabBtn.titleLabel.text= @"pop";
    [tmpTabBtn addTarget:self
                  action:@selector(pop)
        forControlEvents:UIControlEventTouchUpInside];
    tmpTabBtn.backgroundColor=[UIColor clearColor];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem * tmpBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpTabBtn];
    
    self.navigationItem.leftBarButtonItem = tmpBarBtn;
    [tmpBarBtn release];
    
    
    
    self.itemsArry = [NSMutableDictionary dictionary];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[TestCallViewController class]];
    [arr addObject:@"TestCallViewController"];
     [arr addObject:@"push"];
    [self.itemsArry setValue:arr forKey:@"来电头像测试"];
    
    NSMutableArray *arr1 = [NSMutableArray array];
    [arr1 addObject:[ViewController class]];
    [arr1 addObject:@"ViewController"];
    [arr1 addObject:@"selfpresent"];
    [self.itemsArry setValue:arr1 forKey:@"sendobject"];

    
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
    
    
    NSMutableArray *arr  = [self.itemsArry objectForKey:Key];
    UIViewController *tmpViewController =nil;
    if ([arr count]==2) {
        tmpViewController = [[[[arr objectAtIndex:0] alloc] init] autorelease];
    }
    else if([arr count]==3)
    {
        tmpViewController = [[[[arr objectAtIndex:0] alloc] initWithNibName:[arr objectAtIndex:1] bundle:nil] autorelease];
    }
    if (tmpViewController) {
        tmpViewController.title = Key;
        
        if ([[arr objectAtIndex:2] isEqual:@"push"]) {
             [self.navigationController pushViewController:tmpViewController animated:YES];
        }
        else  if ([[arr objectAtIndex:2] isEqual:@"present"])
        {
            [self.navigationController presentModalViewController:tmpViewController animated:YES];
            
        
        }
        else
        {
            [self present:tmpViewController];
        }
    
    }


}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qipao_gray.png"]]];  //设置背景颜色
}






-(void)present:(UIViewController*)viewController
{
    
    //    ViewController* homeViewController_ = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //    [self.navigationController pushViewController:homeViewController_ animated:YES];
    //    [homeViewController_ release];
    
    
//    ViewController* viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    nav = [UINavigationController alloc];
   
    //    ViewController *vc = viewController;
    
    // manually trigger the appear method
//    [viewController viewDidAppear:YES];
    
    //    vc.launcherImage = launcher;
    [nav initWithRootViewController:viewController];
    //[nav viewDidAppear:YES];
    
    nav.view.alpha = 0.f;
    nav.view.transform = CGAffineTransformMakeScale(.1f, .1f);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
//    [nav.view setFrame:CGRectMake(window.bounds.size.width/2,window.bounds.size.height/2, 0, 0)];
     [window addSubview:nav.view];
    [UIView animateWithDuration:.3f  animations:^{
        // fade out the buttons
        //        for(SEMenuItem *item in self.items) {
        //            item.transform = [self offscreenQuadrantTransformForView:item];
        //            item.alpha = 0.f;
        //        }
        
        // fade in the selected view
        nav.view.alpha = 1.f;
        nav.view.transform = CGAffineTransformIdentity;

        [nav.view setFrame:CGRectMake(0,20, self.view.bounds.size.width, self.view.bounds.size.height+45)];
        
//        self.navigationController.navigationBar.hidden = YES;
//        [viewController.view setFrame:CGRectMake(0,-20, window.bounds.size.width, window.bounds.size.height)];
        
        // fade out the top bar
        //        [navigationBar setFrame:CGRectMake(0, -44, 320, 44)];
    }];
    

}
-(void)pop
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:nav.view];
    //    [[AppDelegate sharedApplication] hiddenTabBar:NO];
    //    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeViewEventHandler: (NSNotification *) notification {
    UIView *viewToRemove = (UIView *) notification.object;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
    [UIView animateWithDuration:.3f animations:^{
        viewToRemove.alpha = 0.f;
        viewToRemove.transform = CGAffineTransformMakeScale(.1f, .1f);
        [nav.view setFrame:CGRectMake(window.bounds.size.width/2,window.bounds.size.height/2, 0, 0)];
        //        for(SEMenuItem *item in self.items) {
        //            item.transform = CGAffineTransformIdentity;
        //            item.alpha = 1.f;
        //        }
        //        [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
        [nav release];
//         self.navigationController.navigationBar.hidden = NO;
//         [[AppDelegate sharedApplication] hiddenTabBar:NO];
    }];
    
    // release the dynamically created navigation bar
   }


@end
