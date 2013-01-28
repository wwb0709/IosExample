//
//  ViewController.m
//  RealTimeCurve
//
//  Created by wu xiaoming on 13-1-24.
//  Copyright (c) 2013年 wu xiaoming. All rights reserved.
//

#import "ViewController.h"
#import "CurveViewController.h"
#import "staticlib.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //所有的资源都在source.bundle这个文件夹里
    NSString* image_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"test.bundle/Icon-72.png"];
    
    UIImageView *imgaeview = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:image_path]] autorelease];
    imgaeview.center = CGPointMake(320/2, 640/2);
    [self.view addSubview:imgaeview];
    staticlib * slib = [[staticlib alloc] init];
    [slib fon_A];
    [slib release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
#ifdef __IPHONE_6_0
-(BOOL)shouldAutorotate
{
   
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
}
- (IBAction)showCurveView:(id)sender
{
    UINavigationController* naviController = (UINavigationController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    UIViewController* curveController =  [[CurveViewController alloc] initWithNibName:@"CurveViewController" bundle:nil];
    [naviController pushViewController:curveController animated:YES];
    [curveController release];
}
@end
