//
//  SHHHomeViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHHomeViewController.h"
#import "SHHHomeNavigationController.h"
#import "ViewController.h"
#import "SHHSearchViewController.h"
#import "MTAnimatedLabel.h"
//#import "ProjectApplication.h"

@implementation SHHHomeViewController

- (id) init
{
    self = [super init];
    if (self)
    {
        self.title = @"首页--";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
       
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //右按钮
    UIButton *tmpTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpTabBtn setFrame:CGRectMake(0, 0, 55, 37)];
    tmpTabBtn.titleLabel.text= @"push";
    [tmpTabBtn addTarget:self
                  action:@selector(push)
        forControlEvents:UIControlEventTouchUpInside];
    tmpTabBtn.backgroundColor=[UIColor clearColor];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    [tmpTabBtn setBackgroundImage:[UIImage imageNamed:@"collect_h.png"] forState:UIControlStateHighlighted];
    UIBarButtonItem * tmpBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpTabBtn];
    
    self.navigationItem.rightBarButtonItem = tmpBarBtn;
    [tmpBarBtn release];
    return;
    
//    MTAnimatedLabel *animatedLabel = [[MTAnimatedLabel alloc] initWithFrame:CGRectMake(50, 50, 320, 100)];
//    //UILabel *animatedLabel = [[UILabel alloc] init];
//
//    animatedLabel.text = @"hello world";
//    animatedLabel.font =  [UIFont fontWithName:@"SnellRoundhand" size:20.0f];
//    [animatedLabel setTint:[UIColor blackColor]];
//  //  animatedLabel.frame  = CGRectMake(50, 50, 320, 100);
//    animatedLabel.textColor = [UIColor blueColor];
//   
//    [self.view addSubview:animatedLabel];
//    [animatedLabel startAnimating];
//    [animatedLabel release];
//    
    
    CGRect viewRect = CGRectMake(0.0f, 50.0f, 345.0f, 50.0f);
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    textLayer.wrapped = YES;
    textLayer.truncationMode = kCATruncationNone;
    UIFont *font = [UIFont fontWithName:@"SnellRoundhand" size:20.0f];
    textLayer.string = @"Lorem Lipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
    textLayer.font = fontRef;
    CFRelease(fontRef);
    
    textLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    textLayer.foregroundColor = [[UIColor blackColor] CGColor];
    textLayer.frame = viewRect;
    
    textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_2/4));

    [textLayer addSublayer:[self shadowAsInverse:textLayer.frame]];
    
    UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, NO, 0);
    [textLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
    
    
    
    //[self.view.layer addSublayer:[self shadowAsInverse:self.view.frame]];
    
    UIImageView *textImageView = [[UIImageView alloc] initWithImage:textImage];
    textImageView.frame = viewRect;
    //[self.view addSubview:textImageView];
    [textImageView release];

	// Do any additional setup after loading the view.
}
- (CAGradientLayer *)shadowAsInverse:(CGRect)rect  
{  
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];  
    CGRect newShadowFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);  
    newShadow.frame = newShadowFrame;  
    //添加渐变的颜色组合  
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];  
    return newShadow;  
}  
-(void)viewWillAppear:(BOOL)animated
{
   //[[AppDelegate sharedApplication] hiddenTabBar:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    // Release any retained subviews of the main view.
}

-(void)push
{
    ViewController* homeViewController_ = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:homeViewController_ animated:YES];
    [homeViewController_ release];
}

@end
