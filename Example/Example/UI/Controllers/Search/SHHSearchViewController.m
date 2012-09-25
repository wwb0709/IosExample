//
//  SHHSearchViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "SHHSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
@implementation SHHSearchViewController
@synthesize animatedLabel;    
- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"搜索";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
   [self.animatedLabel startAnimating];
}
-(void)dealloc
{
    [self.animatedLabel release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor blackColor]];
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.view.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(-0.45f, 0.0f);
    l.endPoint = CGPointMake(0.0f, 0.0f);
    
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    // got to make it a bit bigger if your original path reaches to the edge
    // since the shadow needs to stretch "outside" the frame:
    CGFloat shadowBorder = 50.0;
    maskLayer.frame = CGRectInset( maskLayer.frame, - shadowBorder, - shadowBorder );
    maskLayer.frame = CGRectOffset( maskLayer.frame, shadowBorder/2.0, shadowBorder/2.0 );
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.lineWidth = 0.0;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    CGMutablePathRef pathMasking = CGPathCreateMutable();
    CGPathAddPath(pathMasking, NULL, [UIBezierPath bezierPathWithRect:maskLayer.frame].CGPath);
    CGAffineTransform catShiftBorder = CGAffineTransformMakeTranslation( 20/2.0, 20/2.0);
    CGPathAddPath(pathMasking, NULL, CGPathCreateCopyByTransformingPath(maskLayer.path, &catShiftBorder ) );
    maskLayer.path = pathMasking;

    
    self.view.layer.mask = maskLayer;

    return;
    
   self.animatedLabel = [[MTAnimatedLabel alloc] initWithFrame:CGRectMake(50, 50, 320, 100)];
    //UILabel *animatedLabel = [[UILabel alloc] init];

    self.animatedLabel.text = @"hello world";
    UIFont *font1 =  [UIFont fontWithName:@"Arial-BoldItalicMT" size:24];
    self.animatedLabel.font =font1;
   // [animatedLabel setTint:[UIColor blackColor]];
  //  animatedLabel.frame  = CGRectMake(50, 50, 320, 100);
    self.animatedLabel.textColor = [UIColor darkGrayColor];
   
    [self.view addSubview:self.animatedLabel];
     [self.animatedLabel startAnimating];
    
    
    return;
	// Do any additional setup after loading the view.
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
    
//    textLayer.mask = 
//    textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_2/4));
    
    [self.view.layer addSublayer:textLayer];
//    [textLayer addSublayer:[self shadowAsInverse:textLayer.frame]];
    
//    UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, NO, 0);
//    [textLayer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    
//    
//    
//    [self.view.layer addSublayer:[self shadowAsInverse:self.view.frame]];
//    
//    UIImageView *textImageView = [[UIImageView alloc] initWithImage:textImage];
//    textImageView.frame = viewRect;
//    [self.view addSubview:textImageView];
//    [textImageView release];


    
    return;
    
//    CAShapeLayer* circle = [[CAShapeLayer alloc] init];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGRect textRect = CGRectMake(self.view.bounds.size.width/4, (self.view.bounds.size.height-self.view.bounds.size.width/2)/2, self.view.bounds.size.width/2, self.view.bounds.size.width/2);
//    float midX = CGRectGetMidX(textRect);
//    float midY = CGRectGetMidY(textRect);
//    CGAffineTransform t = CGAffineTransformConcat(
//                                                  CGAffineTransformConcat(
//                                                                          CGAffineTransformMakeTranslation(-midX, -midY), 
//                                                                          CGAffineTransformMakeRotation(-1.57079633/0.99)), 
//                                                  CGAffineTransformMakeTranslation(midX, midY));
//    CGPathAddEllipseInRect(path, &t, textRect);
//    circle.path = path;
//    circle.frame = self.view.bounds;
//    circle.fillColor = [UIColor clearColor].CGColor;
//    circle.strokeColor = [UIColor blackColor].CGColor;
//    circle.lineWidth = 60.0f;
//    [self.view.layer addSublayer:circle];
//    
//    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.duration = 15.0f;
//    animation.fromValue = [NSNumber numberWithFloat:0.0f];
//    animation.toValue = [NSNumber numberWithFloat:1.0f];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [circle addAnimation:animation forKey:@"strokeEnd"];
//    
//    [circle release];
//    
//    UILabel* label = [[UILabel alloc] init];
//    label.text = @"Test Text";
//    label.font = [UIFont systemFontOfSize:20.0f];
//    label.center = CGPathGetCurrentPoint(path);
//    label.transform = CGAffineTransformMakeRotation(1.57079633);
//    [label sizeToFit];
//    [self.view.layer addSublayer:label.layer];
//    
//    CAKeyframeAnimation* textAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    textAnimation.duration = 15.0f;
//    textAnimation.path = path;
//    textAnimation.rotationMode = kCAAnimationRotateAuto;
//    textAnimation.calculationMode = kCAAnimationCubicPaced;
//    textAnimation.removedOnCompletion = NO;
//    [label.layer addAnimation:textAnimation forKey:@"position"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
