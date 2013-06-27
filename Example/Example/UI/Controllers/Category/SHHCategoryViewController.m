//
//  SHHCategoryViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHCategoryViewController.h"
#import "BlockUI.h"
#import "UIView+Shadow.h"

@implementation SHHCategoryViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"分类列表";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
    }
    return self;
}
- (void)showsheet
{

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"item1",@"item2",nil];
    
    [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        NSLog(@"action:%d",buttonIndex);
    }];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.view addSubview:button];
//    button.frame = CGRectMake(50, 50, 100, 44);
//    [button setTitle:@"alert view" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(showsheet) forControlEvents:UIControlEventTouchUpInside];


    
    //***************
    //***************
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 50, 100, 44);
    [button setTitle:@"alert view" forState:UIControlStateNormal];
    
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:@"other",nil];
        [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
            NSLog(@"%d",buttonIndex);
        }];
        
    }];
    
    
    //***************
    //***************
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:button2];
    button2.frame = CGRectMake(170, 50, 100, 44);
    [button2 setTitle:@"action sheet" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showsheet) forControlEvents:UIControlEventTouchUpInside];
//    [button2 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"cancel"
//                                             destructiveButtonTitle:nil
//                                                  otherButtonTitles:@"item1",@"item2",nil];
//
//        [sheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
//            NSLog(@"action:%d",buttonIndex);
//        }];
//        
//        
//    }];
    
    
    //***************
    //***************
    UISwitch *swithControl = [[UISwitch alloc] initWithFrame:CGRectMake(50, 10, 0, 0)];
    [self.view addSubview:swithControl];
    [swithControl handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
        UISwitch *s = sender;
        NSLog(@"value:%@",s.isOn?@"on":@"off");
    }];
    
    
    //***************
    //***************
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 110, 220, 0)];
    [self.view addSubview:slider];
    [slider handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
        UISlider *slider = sender;
        NSLog(@"slider:%f",slider.value);
    }];
    
    
    
    //***************
    //***************
    NSArray *items = [NSArray arrayWithObjects:@"item1",@"item2",@"item3", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.frame = CGRectMake(50, 150, 220, 44);
    [self.view addSubview:segment];
    [segment handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
        UISegmentedControl *segment = sender;
        NSLog(@"segment change to %d",segment.selectedSegmentIndex);
    }];
    
    
    
    
    //***************
    //***************
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 0, 0)];
    [self.view addSubview:datePicker];
    [datePicker handleControlEvent:UIControlEventValueChanged withBlock:^(id sender) {
        UIDatePicker *picker = sender;
        NSLog(@"date:%@",picker.date);
    }];
    
    
    UIView *sampleView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [sampleView1 makeInsetShadowWithRadius:5.0 Alpha:0.8];
    [self.view addSubview:sampleView1];
    
    UIView *sampleView2 = [[UIView alloc] initWithFrame:CGRectMake(150, 100, 100, 200)];
    [sampleView2 makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1] Directions:[NSArray arrayWithObjects:@"top", @"bottom", nil]];
    [self.view addSubview:sampleView2];
    
	// Do any additional setup after loading the view.
}

@end
