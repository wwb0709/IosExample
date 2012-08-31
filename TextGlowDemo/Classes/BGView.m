//
//  BGView.m
//  TextGlowDemo
//
//  Created by wwb on 12-8-28.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "BGView.h"

@implementation BGView


-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
		CGFloat colors[] =
		{
			243.0 / 255.0, 181.0 / 255.0, 206.0 / 255.0, 1.00,
			207.0 / 255.0, 170.0 / 255.0, 185.0 / 255.0, 1.00,
		};
		gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
		CGColorSpaceRelease(rgb);
	}
	return self;
}

- (void)dealloc{
	CFRelease(gradient);
	[super dealloc];
}

// Returns an appropriate starting point for the demonstration of a linear gradient
CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y);
}

// Returns an appropriate ending point for the demonstration of a linear gradient
CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height);
}


void drawLinearGradient(CGContextRef context,
                        
                        CGRect rect,
                        
                        CGColorRef startColor,
                        
                        CGColorRef endColor)

{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = {0.0,1.0}; //颜色所在位置
    
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor,(id)endColor, nil];//渐变颜色数组
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);//构造渐变
    
    
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    
    
    CGContextSaveGState(context);//保存状态，主要是因为下面用到裁剪。用完以后恢复状态。不影响以后的绘图
    
    CGContextAddRect(context, rect);//设置绘图的范围
    
    CGContextClip(context);//裁剪
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);//绘制渐变效果图
    
    CGContextRestoreGState(context);//恢复状态
    
    
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}

- (void)drawRect:(CGRect)rect{
//	CGPoint start, end;
//	
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	
//	CGContextSaveGState(context);
//	CGContextClipToRect(context, rect);
//	
//	start = demoLGStart(rect);
//	end = demoLGEnd(rect);
//	CGContextDrawLinearGradient(context, gradient, start, end, 0);
//	CGContextRestoreGState(context);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    
    CGColorRef lightGrayColor = [UIColor colorWithRed: 230.0 / 255.0 
                                 
                                               green: 230.0 / 255.0 
                                 
                                                blue: 230.0 / 255.0 
                                 
                                               alpha:1.0].CGColor;
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor,lightGrayColor);
    
    CGContextSetStrokeColorWithColor(context, lightGrayColor);
    
    CGRect newrRect = CGRectInset(paperRect, 1.5, 1.5);//构造位置
    
    CGContextSetLineWidth(context, 1);//设置笔宽
    
    CGContextStrokeRect(context, newrRect);//绘图
}

@end
