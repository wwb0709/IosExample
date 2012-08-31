//
//  MyString.m
//  TextGlowDemo
//
//  Created by wwb on 12-8-28.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "MyString.h"
#define FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:24]

@implementation MyString

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)settext:(NSString *)te
{
    if (text!=nil)
    {
        [text release];
        text = nil;
    }
    text = [te retain];
    CGSize size1 = [text sizeWithFont:FONT];
    NSLog(@"%f %f",size1.width,size1.height);
    CGSize size = [text sizeWithFont:FONT constrainedToSize:self.frame.size
                       lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"%f %f",size.width,size.height);
    linenum = size.height/size1.height;
    hight = size.height;
    len = 0;
    if ([t isValid])
    {
        [t invalidate];
        [t release];
    }
    t = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.01 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
    [self setNeedsDisplay];
}
-(void)timerFired:(NSTimer*)timer
{
    NSLog(@"timer运行");
    //[t invalidate];
    //[t release];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    int linew = rect.size.width;
    int linehighe = hight/linenum;
    int line = len/linew;
    int linex = len%linew;
    NSLog(@"行数：%d 烈数：%d",line,linex);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (line>0)
    {
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextFillRect(context, CGRectMake(0.0,0.0,linew,line*linehighe));
    }
    if (linex>0)
    {
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextFillRect(context, CGRectMake(0.0,line*linehighe,linex,linehighe));
    }
    CGContextSetRGBFillColor(context, 0.5, 0.1, 0.8, 1);
    CGContextFillRect(context, CGRectMake(linex,line*linehighe,linew - linex,linehighe));
    CGContextFillRect(context, CGRectMake(0.0,(line+1)*linehighe,linew,(linenum-1-line)*linehighe));
    CGImageRef alphaMask = CGBitmapContextCreateImage(context);
    CGContextRestoreGState(context);
    /*
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSaveGState(context);
     CGContextSetRGBFillColor(context, 0.5, 0.1, 0.8, 1);
     CGContextFillRect(context, CGRectMake(0.0, 0.0, rect.size.width/2,rect.size.height));
     CGContextSetRGBFillColor(context, 1, 1, 1, 1);
     CGContextFillRect(context, CGRectMake(rect.size.width/2, 0, rect.size.width/2,rect.size.height));
     CGImageRef alphaMask = CGBitmapContextCreateImage(context);
     CGContextRestoreGState(context);
     */
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 1);
    CGContextFillRect(context, rect);
    CGContextClipToMask(context, rect, alphaMask);
    [[UIColor greenColor] setFill];
    [text drawInRect:rect withFont:FONT];
    
    ////////////
    
    
    
    
    //画长方形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置颜色，仅填充4条边
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] CGColor]);
    //设置线宽为1
    CGContextSetLineWidth(ctx, 1.0);
    //设置长方形4个顶点
    CGPoint poins[] = {CGPointMake(5, 5),CGPointMake(425, 5),CGPointMake(425, 125),CGPointMake(5, 125)};
    CGContextAddLines(ctx,poins,4);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //画直线，x1和y1是起始点，x2和y2是结束点
    //默认坐标系左上角为0，0
    CGContextMoveToPoint(ctx, 5, 5);
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //画文字，设置文字内容
    NSString *text1 = @"text";
    //设置字体大小
    UIFont *font = [UIFont systemFontOfSize:15];
    //在指定x，y点位置画文字，宽度为18
    [text1 drawAtPoint:CGPointMake( 100, 100) forWidth:50 withFont:font
          minFontSize:15 actualFontSize:NULL
        lineBreakMode:UILineBreakModeTailTruncation
   baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    

    

    /////////
    
    
    CGImageRelease(alphaMask);
    CGContextRestoreGState(context);
    len++;
}
- (void)dealloc {
    [super dealloc];
}
@end
