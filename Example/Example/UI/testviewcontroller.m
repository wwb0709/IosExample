//
//  testviewcontroller.m
//  AiHao
//
//  Created by wwb on 12-6-21.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "testviewcontroller.h"

@implementation testviewcontroller
@synthesize userService;


#pragma mark 新的网络回调接口
-(void)DARequestFinish:(DARequestEntity*)requestEntity{
    if(requestEntity.RRequestType==DARequestType_SendInstall)
    {
        if( [requestEntity.RServerCode isEqualToString:@"success"])
        {
            printLog(@"return success");
            
        }
        else
        {
            printLog(@"return fail");
        }
        
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   UIButton * tmpBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //        if (i==1) {
    //            [btn setBackgroundColor:[UIColor greenColor]];
    //        }
    tmpBtn3.titleLabel.text = @"testPost";
    [tmpBtn3 setBackgroundImage:[UIImage imageNamed:@"tabitem.png"] forState:UIControlStateNormal];

    tmpBtn3.frame = CGRectMake(100,100, 40, 40);
    [tmpBtn3 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
     
    [self.view  addSubview:tmpBtn3];

    
    self.userService = [[UserService alloc] init];
    self.userService.delegate = self;

    // Do any additional setup after loading the view from its nib.
}

- (void)selectedTab:(id)sender
{
        [self.userService testPost];
//    UIButton *u = (UIButton *)sender;
//    u.selected = YES;//选择状态设置为YES,如果有其他按钮 先把其他按钮的selected设置为NO
//    u.userInteractionEnabled = NO;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    if (nil !=userService) {
        [userService release];
        userService = nil;
    }
    [super dealloc];
}
@end
