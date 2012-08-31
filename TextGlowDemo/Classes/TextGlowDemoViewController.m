//
//  TextGlowDemoViewController.m
//  TextGlowDemo
//
//  Created by Andrew on 28/04/2010.
//  Red Robot Studios 2010.
//

#import "TextGlowDemoViewController.h"

#import "MyString.h"
#import "BGView.h"
@implementation TextGlowDemoViewController

@synthesize label, glowSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    

	CGRect bgframe = CGRectMake(5.0, 5.0, 320, 10);//按世纪需求来定
	BGView *bgView = [[BGView alloc] initWithFrame:bgframe];
	[self.view addSubview:bgView];
	[bgView release];
    return;
    
    
    MyString *my = [[MyString alloc]initWithFrame:CGRectMake(0.0, 0.0, 320, 460)];
    my.backgroundColor = [UIColor blueColor];
    [self.view addSubview:my];
    [my settext:@"hello world!!"];
    [my release];
    return;
    
    
    
    
    /////////////////////////
    CALayer *maskLayer = [CALayer layer];
    [maskLayer setBounds:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    
    // Center the layer
    [maskLayer setPosition:CGPointMake([self view].bounds.size.width/2, 
                                       [self view].bounds.size.height/2)];
    
    // Set the cornerRadius to half the width/height to get a circle.
    [maskLayer setCornerRadius:50.f];
    [maskLayer setMasksToBounds:YES];
    
    // Any solid color will do. Just using black here.
    [maskLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    
    // Set the mask which will only allow that which is in the
    // circle show through
    [[[self view] layer] setMask:maskLayer];

    return;
    
    //Create a couple of colours for the background gradient
    UIColor *colorOne = [UIColor colorWithRed:0.0 green:0.125 blue:0.18 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:0.0 green:0.00 blue:0.05 alpha:1.0];
    
    //Create the gradient and add it to our view's root layer
    CAGradientLayer *gradientLayer = [[[CAGradientLayer alloc] init] autorelease];
    gradientLayer.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil]];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    //Set the label properties and glow params
    self.label.textColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0];
    self.label.glowColor = self.label.textColor;
    self.label.glowOffset = CGSizeMake(0.0, 0.0);
    self.label.glowAmount = 30.0;
    
    
    
    float wd = 320.0;
    float ht = 480.0;
    CGContextRef myContext = [self MyCreateBitmapContext:wd:ht];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:[self createDialogBox:myContext: 50: 350: 100: 60: 5: 7 ]];
    [self.view addSubview:iv];
    CGContextRelease (myContext);
    [iv release];
}

- (IBAction)adjustGlowAmount:(id)sender {
    self.label.glowAmount = self.glowSlider.value;
    [self.label setNeedsDisplay];
}

-(void)viewDidUnload {
    [super viewDidUnload];
    self.glowSlider = nil;
    self.label = nil;
}

- (void)dealloc {
    [label release];
    [glowSlider release];
    [super dealloc];
}

- (CGContextRef) MyCreateBitmapContext: (int) pixelsWide :
                                    (int) pixelsHigh
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    //声明一个变量来代表每行的字节数。每一个位图像素的代表是4个字节，8bit红，8bit绿，8bit蓝，和8bit alpha通道信息(透明信息)。
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();// 创建一个通用的RGB色彩空间
    bitmapData = malloc( bitmapByteCount );// 调用的malloc函数来创建的内存用来存储位图数据块
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    
    //创建一个位图图形上下文
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    //释放colorSpace 注意使用的函数
    CGColorSpaceRelease( colorSpace );
    return context;
}

/*
 生成一个聊天的对话框背景图
 参数
 myContext:一个图形上下文
 ox: 矩形左下角x坐标
 oy: 矩形左下角y坐标
 rw: 矩形宽度
 rh: 矩形高度
 r : 矩形圆角半径
 Orientation: 箭头方向，0-7 
 */
-(UIImage*) createDialogBox: (CGContextRef) myContext : (float) ox : (float) oy :(float) rw : (float) rh : (float) r:  (int) Orientation
{
    CGMutablePathRef path = CGPathCreateMutable();
    //画矩形
    CGPathMoveToPoint(path, NULL,ox, oy+r);
    CGPathAddArcToPoint(path, NULL, ox, oy+rh, ox+r,oy+rh, r);
    CGPathAddArcToPoint(path, NULL, ox+rw, oy+rh, ox+rw, oy+rh-r, r);
    CGPathAddArcToPoint(path, NULL, ox+rw, oy, ox+rw-r, oy, r);
    CGPathAddArcToPoint(path, NULL, ox, oy, ox,oy+r,r);
    //画箭头
    switch (Orientation) {
        case 0:
            CGPathMoveToPoint(path, NULL,ox+r+10.0, oy+rh);
            CGPathAddLineToPoint(path, NULL, ox+r+10.0, oy+rh+20);
            CGPathAddLineToPoint(path, NULL, ox+r+30.0, oy+rh);
            break;
        case 1:
            CGPathMoveToPoint(path, NULL,ox+rw-r-10.0, oy+rh);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-10.0, oy+rh+20);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-30.0, oy+rh);
            break;
        case 2:
            CGPathMoveToPoint(path, NULL,ox+rw, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox+rw+20, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox+rw, oy+rh-r-30);
            break;
        case 3:
            CGPathMoveToPoint(path, NULL,ox+rw, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox+rw+20, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox+rw, oy+r+30);
            break;
        case 4:
            CGPathMoveToPoint(path, NULL,ox+rw-r-10.0, oy);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-10.0, oy-20);
            CGPathAddLineToPoint(path, NULL, ox+rw-r-30.0, oy);
            break;
        case 5:
            CGPathMoveToPoint(path, NULL,ox+r+10.0, oy);
            CGPathAddLineToPoint(path, NULL, ox+r+10.0, oy-20);
            CGPathAddLineToPoint(path, NULL, ox+r+30.0, oy);
            break;
        case 6:
            CGPathMoveToPoint(path, NULL,ox, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox-20, oy+r+10);
            CGPathAddLineToPoint(path, NULL, ox, oy+r+30);
            break;
        case 7:
            CGPathMoveToPoint(path, NULL,ox, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox-20, oy+rh-r-10);
            CGPathAddLineToPoint(path, NULL, ox, oy+rh-r-30);
            break;
        default:
            break;
    }
    //描边 以及添加阴影效果
    CGContextSetLineJoin(myContext, kCGLineJoinRound);
    CGFloat zStrokeColour[4]    = {180.0/255, 180.0/255.0, 180.0/255.0, 1.0};
    CGContextSetLineWidth(myContext, 13.0);
    CGContextAddPath(myContext,path);
    CGContextSetStrokeColorSpace(myContext, CGColorSpaceCreateDeviceRGB());
    CGContextSetStrokeColor(myContext, zStrokeColour);
    CGContextStrokePath(myContext);
    CGSize myShadowOffset = CGSizeMake (0,  0);
    CGContextSaveGState(myContext);
    
    CGContextSetShadow (myContext, myShadowOffset, 5);
    CGContextSetLineJoin(myContext, kCGLineJoinRound);
    CGFloat zStrokeColour1[4]    = {228.0/255, 168.0/255.0, 81.0/255.0, 1.0};
    CGContextSetLineWidth(myContext, 3.0);
    CGContextAddPath(myContext,path);
    CGContextSetStrokeColorSpace(myContext, CGColorSpaceCreateDeviceRGB());
    CGContextSetStrokeColor(myContext, zStrokeColour1);
    CGContextStrokePath(myContext);
    CGContextRestoreGState(myContext);
    //填充矩形内部颜色
    CGContextAddPath(myContext,path);
    CGContextSetFillColorSpace(myContext, CGColorSpaceCreateDeviceRGB());
    CGFloat zFillColour1[4]    = {229.0/255, 229.0/255.0, 231.0/255.0, 1};
    CGContextSetFillColor(myContext, zFillColour1);
    CGContextEOFillPath(myContext);
    //生成图像
    CGImageRef myImage = CGBitmapContextCreateImage (myContext);
    UIImage * image = [UIImage imageWithCGImage:myImage];
    CGImageRelease(myImage);
    return image;
}
@end
