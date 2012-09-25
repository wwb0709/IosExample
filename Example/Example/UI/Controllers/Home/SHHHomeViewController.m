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
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(closeViewEventHandler:)
     name:@"closeView"
     object:nil ];
    
    
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
//    ViewController* homeViewController_ = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    [self.navigationController pushViewController:homeViewController_ animated:YES];
//    [homeViewController_ release];
    
    
    ViewController* viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    nav = [UINavigationController alloc];
//    ViewController *vc = viewController;
    
    // manually trigger the appear method
    [viewController viewDidAppear:YES];
    
//    vc.launcherImage = launcher;
    [nav initWithRootViewController:viewController];
    [nav viewDidAppear:YES];
    
    nav.view.alpha = 0.f;
    nav.view.transform = CGAffineTransformMakeScale(.1f, .1f);
    [self.view addSubview:nav.view];
    
    [UIView animateWithDuration:.3f  animations:^{
        // fade out the buttons
//        for(SEMenuItem *item in self.items) {
//            item.transform = [self offscreenQuadrantTransformForView:item];
//            item.alpha = 0.f;
//        }
        
        // fade in the selected view
        nav.view.alpha = 1.f;
        nav.view.transform = CGAffineTransformIdentity;
        [nav.view setFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        // fade out the top bar
//        [navigationBar setFrame:CGRectMake(0, -44, 320, 44)];
    }];
    
    [viewController release];
}

- (void)closeViewEventHandler: (NSNotification *) notification {
    UIView *viewToRemove = (UIView *) notification.object;    
    [UIView animateWithDuration:.3f animations:^{
        viewToRemove.alpha = 0.f;
        viewToRemove.transform = CGAffineTransformMakeScale(.1f, .1f);
//        for(SEMenuItem *item in self.items) {
//            item.transform = CGAffineTransformIdentity;
//            item.alpha = 1.f;
//        }
//        [navigationBar setFrame:CGRectMake(0, 0, 320, 44)];
    } completion:^(BOOL finished) {
        [viewToRemove removeFromSuperview];
    }];
    
    // release the dynamically created navigation bar
    [nav release];
}

@end
