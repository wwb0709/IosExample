//
//  testviewcontroller.m
//  AiHao
//
//  Created by wwb on 12-6-21.
//  Copyright (c) 2012年 szty. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "testviewcontroller.h"
#import "BGView.h"
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

//    UIGraphicsBeginImageContext(CGSizeMake(100, 100));
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextBeginPath(context);
//    CGContextAddArc(context, 50,50, 50, 0, 2*M_PI, 1);                 //对应的数值需要和size对应，不然是看不到图像的
//    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
//    CGContextFillPath(context);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.center = CGPointMake(160, 300);
//    [self.view addSubview:imageView];
    
//    [self drawDashedBorderAroundView:self.view];
    
    [self resetBGView];

    return;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation: UIStatusBarAnimationSlide];
    
    UIImage *image=[UIImage imageNamed:@"1.png"];

    //[contentView setImage:image];
    CGRect rect = CGRectMake(0, 0, 384, 512);//创建矩形框

    UIGraphicsBeginImageContext(rect.size);//根据size大小创建一个基于位图的图形上下文

    CGContextRef currentContext = UIGraphicsGetCurrentContext();//获取当前quartz 2d绘图环境

    CGContextClipToRect(currentContext, rect);//设置当前绘图环境到矩形框

    CGContextRotateCTM(currentContext, M_PI);

    CGContextTranslateCTM(currentContext, -rect.size.width, -rect.size.height);

    CGContextDrawImage(currentContext, rect, image.CGImage);//绘图

    //[image drawInRect:rect];

    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();//获得图片

    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:rect];

    contentView.image=cropped;

    //immolation.view=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view addSubview:contentView];
    [cropped release];
    return;
    
    
    UIButton * tmpBtn3 = [[UIButton alloc] init];
    //        if (i==1) {
    //            [btn setBackgroundColor:[UIColor greenColor]];
    //        }
    tmpBtn3.titleLabel.text = @"testPost";
    [tmpBtn3 setBackgroundImage:[UIImage imageNamed:@"tabitem.png"] forState:UIControlStateNormal];

    tmpBtn3.frame = CGRectMake(100,100, 40, 40);
    [tmpBtn3 addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];

    [self.view  addSubview:tmpBtn3];
    
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"1.png"],
                         [UIImage imageNamed:@"2.png"],
                         nil];
    
    UIImageView *myAnimatedView = [UIImageView alloc];
    [myAnimatedView initWithFrame:[self.view bounds]];
    myAnimatedView.animationImages = myImages;
    myAnimatedView.animationDuration = 0.35; // seconds
    myAnimatedView.animationRepeatCount = 0; // 0 代表一直循环。
    [myAnimatedView startAnimating];
    [self.view addSubview:myAnimatedView];
    [myAnimatedView release]; 
    

    UIAlertView* myAlert = [[UIAlertView alloc] initWithTitle:nil
                                         message: @"读取中..."
                                        delegate: self
                               cancelButtonTitle: nil
                               otherButtonTitles: nil];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(120.f, 48.0f, 38.0f, 38.0f);
    [myAlert addSubview:activityView];
    [activityView startAnimating];
    [myAlert show];    
    self.userService = [[UserService alloc] init];
    self.userService.delegate = self;

    // Do any additional setup after loading the view from its nib.
}
- (void)resetBGView{
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	CGRect bgframe = CGRectMake(0, 44 + 20, appFrame.size.width, appFrame.size.height - 44 - 48);//按世纪需求来定
	BGView *bgView = [[BGView alloc] initWithFrame:bgframe];
	[self.view insertSubview:bgView atIndex:0];
	[bgView release];
}


+(CGImageRef)createGradientImage:(CGSize)size{
    CGFloat colors[] = {0.0,1.0,1.0,1.0};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);

    CGColorSpaceRelease(colorSpace);

    CGPoint p1 = CGPointZero;

    CGPoint p2 = CGPointMake(0, size.height);

    CGContextDrawLinearGradient(context, gradient, p1, p2, kCGGradientDrawsAfterEndLocation);

    CGImageRef theCGImage = CGBitmapContextCreateImage(context);

    CFRelease(gradient);

    CGContextRelease(context);

    return theCGImage;

    }

+(UIImage *) reflectionOfView : (UIView *)theView withPercent:(CGFloat)percent{

    CGSize size = CGSizeMake(theView.frame.size.width, theView.frame.size.height*percent);

    UIGraphicsBeginImageContext(size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    [theView.layer renderInContext:context];

    UIImage *partialimg = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

//CGImageRef mask = [ImageHelper createGradientImage:size];

    CGImageRef mask = [testviewcontroller createGradientImage:size];

    CGImageRef ref = CGImageCreateWithMask(partialimg.CGImage, mask);

    UIImage *theImage = [UIImage imageWithCGImage:ref];

    CGImageRelease(ref);

    CGImageRelease(mask);

    return theImage;

}

+(void)addReflectionToView:(UIView *)theView{

    CGFloat kReflectDistance = 10.0f;

    theView.clipsToBounds = NO;

    UIImageView *reflection = [[UIImageView alloc] initWithImage:[testviewcontroller reflectionOfView:theView withPercent:0.45f]];

    CGRect frame = reflection.frame;

    frame.origin = CGPointMake(0.0f, theView.frame.size.height + kReflectDistance);

    reflection.frame = frame;

    [theView addSubview:reflection];
    
    [reflection release];

}
- (void)drawDashedBorderAroundView:(UIView *)v
{
    //border definitions
	CGFloat cornerRadius = 10;
	CGFloat borderWidth = 2;
	NSInteger dashPattern1 = 8;
	NSInteger dashPattern2 = 8;
	UIColor *lineColor = [UIColor orangeColor];
    
    //drawing
	CGRect frame = v.bounds;
    
	CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
	CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, frame.size.height/2);
    CGPathAddLineToPoint(path, NULL, frame.size.width/2, frame.size.height/2);
    CGPathAddArc(path, NULL, frame.size.width/2-cornerRadius, frame.size.height/2+cornerRadius, cornerRadius, 0, M_PI, NO);
    //drawing a border around a view
//	CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
//	CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
//	CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
//	CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
//	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
//	CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
//	CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
//	CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
//	CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
	_shapeLayer.path = path;
	CGPathRelease(path);
    
	_shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
	_shapeLayer.frame = frame;
	_shapeLayer.masksToBounds = NO;
	[_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
	_shapeLayer.fillColor = [[UIColor clearColor] CGColor];
	_shapeLayer.strokeColor = [lineColor CGColor];
	_shapeLayer.lineWidth = borderWidth;
	_shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
	_shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
	[v.layer addSublayer:_shapeLayer];
	v.layer.cornerRadius = cornerRadius;
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
