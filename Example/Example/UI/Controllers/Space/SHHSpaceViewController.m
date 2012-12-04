//
//  SHHSpaceViewController.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by sui huan on 12-9-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//
#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }
#import "SHHSpaceViewController.h"
#import "SHHHomeViewController.h"
//#import "ProjectApplication.h"

@implementation SHHSpaceViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"个人空间";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
    }
    return self;
}


-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSUTF8StringEncoding];
    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
//    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    CGContextShowTextAtPoint(context, 60,  h/2, text, strlen(text));
    CGContextSetRGBFillColor(context, 255, 255, 0, 0.5);
    CGContextShowTextAtPoint(context, 60, 600, text, strlen(text));
    
    
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, w,h);
//    CGContextStrokePath(context);
    
    //设置矩形填充颜色：红色
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    //设置画笔颜色：黑色
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 0.6);
    
    //扇形参数
    double radius=40;//半径
    int startX=50;//圆心x坐标
    int startY=50;//圆心y坐标
    double pieStart=0;//起始的角度
    double pieCapacity=60;//角度增量值
    int clockwise=0;//0=逆时针,1=顺时针
    
    //逆时针画扇形
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddArc(context, startX, startY, radius, radians(pieStart), radians(pieStart+pieCapacity), clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    //扇形参数
    startX=60;//圆心x坐标
    startY=1000;//圆心y坐标
    pieStart=0;//起始的角度
    pieCapacity=60;//角度增量值
    clockwise=1;//0=逆时针,1=顺时针
    
    //顺时针画扇形
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddArc(context, startX, startY, radius, radians(pieStart), radians(pieStart+pieCapacity), clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context,  w,h);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    
}
-(UIImage *)addText2:(UIImage *)img text:(NSString *)text1
{
    int w = img.size.width;
    int h = img.size.height;

    CGSize size =CGSizeMake(w, h); //设置上下文（画布）大小
    UIGraphicsBeginImageContext(size); //创建一个基于位图的上下文(context)，并将其设置为当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
    CGContextTranslateCTM(contextRef, 0, h);  //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, w, h), [img CGImage]);  //在上下文种画当前图片
    
    
    [[UIColor redColor] set];  //上下文种的文字属性
    CGContextTranslateCTM(contextRef, 0, h);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    UIFont *font = [UIFont boldSystemFontOfSize:40];
    [text1 drawInRect:CGRectMake(0, 0, 200, 80) withFont:font];
    
    //设置矩形填充颜色：红色
    CGContextSetRGBFillColor(contextRef, 1.0, 0.0, 0.0, 1.0);
    //设置画笔颜色：黑色
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 0, 1);
    //设置画笔线条粗细
    CGContextSetLineWidth(contextRef, 0.6);
    
    //扇形参数
    double radius=40;//半径
    int startX=50;//圆心x坐标
    int startY=50;//圆心y坐标
    double pieStart=0;//起始的角度
    double pieCapacity=60;//角度增量值
    int clockwise=0;//0=逆时针,1=顺时针
    
    //逆时针画扇形
    CGContextMoveToPoint(contextRef, startX, startY);
    CGContextAddArc(contextRef, startX, startY, radius, radians(pieStart), radians(pieStart+pieCapacity), clockwise);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathEOFillStroke);
    
    
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); //移除栈顶的基于当前位图的图形上下文。
    return  res;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage* image = [UIImage imageNamed:@"iphone5.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];

    [imageView setImage:[self addText2:image text:@"hello"]];
    [self.view addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 160.0f, 160.0f)];
    [imageView2 setImage:[UIImage imageNamed:@"bubbleMine.png"]];
    
   
   // imageView.layer.mask = imageView2.layer;
    
    [imageView release];
    
  
    
    return;
//    UIImage *img = [UIImage imageNamed:@"iphone5.png"];  //需要加水印的图片
//    UIImage *smallImg = [UIImage imageNamed:@"bubbleMine.png"];
//    CGSize size = self.view.frame.size; //设置上下文（画布）大小
//    UIGraphicsBeginImageContext(size); //创建一个基于位图的上下文(context)，并将其设置为当前上下文
//    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
//    CGContextTranslateCTM(contextRef, 0, self.view.bounds.size.height);  //画布的高度
//    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
//    
//    CGContextDrawImage(contextRef, self.view.frame, [img CGImage]);  //在上下文种画当前图片
//    CGContextDrawImage(contextRef, CGRectMake(100, 100, 200, 80), [smallImg CGImage]);
//    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext(); //移除栈顶的基于当前位图的图形上下文。
//    NSArray *savePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *p = [savePath objectAtIndex:0];
//    NSLog(@"%@",p);
//    NSString *dataFilePath = [p stringByAppendingPathComponent:@"1.png"];
//    
//    NSData *imageData = UIImageJPEGRepresentation(res, 1.0);
//    [imageData writeToFile:dataFilePath atomically:YES];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [imageView setImage:res];
//    [self.view addSubview:imageView];
    
    
//    UIImage *img = [UIImage imageNamed:@"iphone5.png"];  //需要加水印的图片
//    
//    CGSize size = self.view.frame.size; //设置上下文（画布）大小
//    UIGraphicsBeginImageContext(size); //创建一个基于位图的上下文(context)，并将其设置为当前上下文
//    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
//    NSString *title = @"舵手网络";  //需要添加的水印文字
//    CGContextTranslateCTM(contextRef, 0, self.view.bounds.size.height);  //画布的高度
//    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
//    CGContextDrawImage(contextRef, self.view.frame, [img CGImage]);  //在上下文种画当前图片
//    
//    [[UIColor redColor] set];  //上下文种的文字属性
//    CGContextTranslateCTM(contextRef, 0, self.view.bounds.size.height);
//    CGContextScaleCTM(contextRef, 1.0, -1.0);
//    UIFont *font = [UIFont boldSystemFontOfSize:40];
//    [title drawInRect:CGRectMake(100, 100, 200, 80) withFont:font];
//    UIImage *res =UIGraphicsGetImageFromCurrentImageContext();  //从当前上下文种获取图片
//    UIGraphicsEndImageContext(); //移除栈顶的基于当前位图的图形上下文。
//    NSArray *savePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *p = [savePath objectAtIndex:0];
//    NSLog(@"%@",p);
//    NSString *dataFilePath = [p stringByAppendingPathComponent:@"1.png"];
//    
//    NSData *imageData = UIImagePNGRepresentation(res);
//    [imageData writeToFile:dataFilePath atomically:YES];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [imageView setImage:res];
//    [self.view addSubview:imageView];
	// Do any additional setup after loading the view.
}

@end
