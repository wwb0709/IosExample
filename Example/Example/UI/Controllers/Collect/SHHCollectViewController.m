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
#import "testFtpViewController.h"
#import "HHDetailViewController.h"
#import "HHDetailView1Controller.h"
#import "AnimalLabelViewController.h"
@interface SHHCollectViewController ()

@end


@implementation SHHCollectViewController
@synthesize tableview;
@synthesize itemsArry;
@synthesize myblocks;
@synthesize idsArry;

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	if ([viewController isKindOfClass:[SecondViewController class]])
    //	{
    //        [leveyTabBarController hidesTabBar:NO animated:YES];
    //	}
    
    if (viewController.hidesBottomBarWhenPushed)
    {
        
//        [leveyTabBarController hidesTabBar:YES animated:YES];
    }
    else
    {
//        [leveyTabBarController hidesTabBar:NO animated:YES];
    }
}



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
-(void)viewWillAppear:(BOOL)animated
{
     [[AppDelegate sharedApplication] hiddenTabBar:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[AppDelegate sharedApplication] hiddenTabBar:YES];
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

    
    self.idsArry =  [NSMutableArray array];
 
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
    [self.itemsArry setValue:arr1 forKey:@"sms对话"];
    
    
    
    NSMutableArray *arr2 = [NSMutableArray array];
    [arr2 addObject:[testFtpViewController class]];
    [arr2 addObject:@"testFtpViewController"];
    [arr2 addObject:@"push"];
    [self.itemsArry setValue:arr2 forKey:@"ftptest"];
    
    
    NSMutableArray *arr3 = [NSMutableArray array];
    [arr3 addObject:[InputViewController class]];
    [arr3 addObject:@"InputViewController"];
    [arr3 addObject:@"present"];
    [self.itemsArry setValue:arr3 forKey:@"sendobject"];
    
    NSMutableArray *arr4 = [NSMutableArray array];
    [arr4 addObject:[HHDetailViewController class]];
    [arr4 addObject:@"HHDetailViewController"];
    [arr4 addObject:@"push"];
    [self.itemsArry setValue:arr4 forKey:@"向下滑动"];
    
    NSMutableArray *arr5 = [NSMutableArray array];
    [arr5 addObject:[HHDetailView1Controller class]];
    [arr5 addObject:@"HHDetailView1Controller"];
    [arr5 addObject:@"push"];
    [self.itemsArry setValue:arr5 forKey:@"向右滑动"];
    
    NSMutableArray *arr6 = [NSMutableArray array];
    [arr6 addObject:[AnimalLabelViewController class]];
    [arr6 addObject:@"AnimalLabelViewController"];
    [arr6 addObject:@"push"];
    [self.itemsArry setValue:arr6 forKey:@"animationlabel"];
    
    

    
    UITableView *tmpTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-45-50)];
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
        UIActivityIndicatorView *activeIndicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [cell.imageView addSubview:activeIndicatorView];//[UIImage imageNamed:@"process.png"];
        
        [activeIndicatorView release];
        
        [[cell.imageView.subviews lastObject]  startAnimating];
       
        [[cell.imageView.subviews lastObject] setFrame:CGRectMake(30, 30,20, 20)];
        
        cell.imageView.image = [UIImage imageNamed:@"201209172227.png"];
       
        //设置一个default图片，要不然activityindicator不会显示
    }
    

    NSString * tmpSectionKey = [[self.itemsArry allKeys] objectAtIndex:rowIdx];
    cell.textLabel.text = tmpSectionKey;
    

    
//     NSMutableArray *arr  = [self.itemsArry objectForKey:tmpSectionKey];
    if ([self.idsArry containsObject:[NSNumber numberWithInteger:rowIdx]]) {
        return cell;
    }
    
    //下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://www.rrsc.cn/png/Ico/201209172227.png"];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        
        dispatch_async(dispatch_get_main_queue (), ^{
            [[cell.imageView.subviews lastObject] removeFromSuperview];
            cell.imageView.image = image; // 在主线程中更新imageview
            cell.imageView.alpha = 0;
            [UIView animateWithDuration:1.3 animations:^{

                cell.imageView.alpha = 1;
                
                
            } completion:^(BOOL finished){
                              
            }];
//            NSMutableArray *arr  = [self.itemsArry objectForKey:tmpSectionKey];
//            [arr addObject:@"hasadded"];
            
            [self.idsArry addObject:[NSNumber numberWithInteger:rowIdx]];
            
        });
        
    });
    
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
            
//            tmpViewController.hidesBottomBarWhenPushed = YES;
             self.navigationController.delegate = self;
//             [[AppDelegate sharedApplication] hiddenTabBar:YES];
             [self.navigationController pushViewController:tmpViewController animated:YES];
        }
        else  if ([[arr objectAtIndex:2] isEqual:@"present"])
        {
            [self.navigationController presentModalViewController:tmpViewController animated:YES];
            NSString *str= @"111112w222";
            
           
            self.myblocks = ^(id object) {
                 printLog(@"tmpViewController: %@ %@",@"HELLO",str);
            };
            
        
            //看这里
            [tmpViewController receiveObject:self.myblocks];
            
        
            
        
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

     [window addSubview:nav.view];
    [UIView animateWithDuration:.3f  animations:^{

        // fade in the selected view
        nav.view.alpha = 1.f;
        nav.view.transform = CGAffineTransformIdentity;

        [nav.view setFrame:CGRectMake(0,20, self.view.bounds.size.width, self.view.bounds.size.height+100)];
        
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

    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
        [nav release];
    }];
    
    // release the dynamically created navigation bar
   }


@end
