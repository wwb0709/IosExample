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
    
    
    isFlip = NO;
    frontImageView = [[UIImageView alloc] initWithImage:[UIImage
                                                         imageNamed:@"bubbleMine.png"]];
    
    containerView = [[UIView alloc] initWithFrame:frontImageView.bounds];
    containerView.center = CGPointMake(200,200);
    [self flipImage:frontImageView Horizontal:NO];
    [self.view addSubview:containerView];
    [containerView addSubview:frontImageView];
    
    backImageView = [[UIImageView alloc] initWithImage:[UIImage
                                                        imageNamed:@"bubbleSomeone.png"]];
    backImageView.center = frontImageView.center;

    
    //右按钮
    UIButton *tmpTabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpTabBtn setFrame:CGRectMake(0, 0, 55, 37)];
    tmpTabBtn.titleLabel.text= @"push";
    [tmpTabBtn addTarget:self
                  action:@selector(flipButtonClicked:)
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

-(IBAction)flipButtonClicked:(id)sender
{
//    CGRect viewRect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
//    UIView *containerView  = [[UIView alloc] initWithFrame:viewRect];
////    containerView.center = self.view.center;
//    
//    
//    UIImageView* frontImageView = [[UIImageView alloc] initWithImage:[UIImage
//                                                                     imageNamed:@"bubbleMine.png"]];
//    frontImageView.center = containerView.center;
//    [containerView addSubview:frontImageView];
//    
//    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage
//                                                        imageNamed:@"bubbleSomeone.png"]];
//    backImageView.center = frontImageView.center;
//    [containerView addSubview:backImageView];
//    [self.view addSubview:containerView];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1.0];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
//                           forView:containerView
//                             cache:YES];
////    [frontImageView removeFromSuperview];
////    [containerView addSubview:backImageView];
//    [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//    [UIView commitAnimations];
//    
//    [frontImageView release];
//    [backImageView release];
//    [containerView release];

    

    [UIView beginAnimations:@"moveup" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:containerView
                             cache:YES];
    if (!isFlip) {
        isFlip = YES;
        [frontImageView removeFromSuperview];
        [containerView addSubview:backImageView];
    }
    else{
        isFlip = NO;
        [backImageView removeFromSuperview];
        [containerView addSubview:frontImageView];
    }
    [UIView setAnimationDidStopSelector:@selector(animationMoveDidStop)];
    [UIView commitAnimations];

    
    
}

/*
 *UIView动画结束后的默认通知方法
 */
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"moveup"] == NSOrderedSame)
    {
        [self deleteanimationView:containerView FromPoint:CGPointMake(0,0) ToPoint:CGPointMake(200,200)];
    
        //播放其他的动画
    }
    //TODO：其他的动画结束判断
}

-(void) deleteanimationView:(UIView*)aniView FromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint
{
    aniView.hidden = NO;
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];

    [movePath addQuadCurveToPoint:toPoint
      controlPoint:CGPointMake(toPoint.x,fromPoint.y)];


    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;

    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = YES;

    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = YES;

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim,opacityAnim, nil];
    animGroup.duration = 1;
    [aniView.layer addAnimation:animGroup forKey:nil];
    //aniView.hidden = YES;
}

- (UIImageView *) flipImage:(UIImageView *)originalImage Horizontal:(BOOL)flipHorizontal {
    if (flipHorizontal) {
        
        originalImage.transform = CGAffineTransformMake(originalImage.transform.a * -1, 0, 0, 1, originalImage.transform.tx, 0);
    }else {
        
        originalImage.transform = CGAffineTransformMake(1, 0, 0, originalImage.transform.d * -1, 0, originalImage.transform.ty);
    }    
    return originalImage;

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
