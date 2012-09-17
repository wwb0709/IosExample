//
//  BGView.m
//  Example
//
//  Created by wwb on 12-9-17.
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
    
    CGFloat locations[] = {0.0,1.0};
    
    
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor,(id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rect);
    
    CGContextClip(context);
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(context);
    
    
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}


void drawGlossAndGradient1(CGContextRef context,CGRect rect,CGColorRef startColor,CGColorRef endColor)
{
    
    /*
     
     填充渐变效果
     
     */
    
    drawLinearGradient(context, rect, startColor, endColor);
    
    
    
    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
    
    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height / 2);
    
    
    
    /*
     
     利用浅色在次渐变上半层实现玻璃透明效果
     
     */
    
    drawLinearGradient(context, topHalf, glossColor1, glossColor2);
    
}
- (void)drawRect:(CGRect)rect{
    
    CGRect _coloredBoxRect = rect;
    _coloredBoxRect.size = CGSizeMake(rect.size.width, 100);
    
    UIColor* _lightColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f 
                       
                                      blue:216.0f/255.0f alpha:1.0];
    
    UIColor* _darkColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 
                      
                                     blue:136.0/255.0 alpha:1.0]; 
    // Drawing code
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    
    
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 
                             
                                            blue:1.0 alpha:1.0].CGColor;
    
    CGColorRef lightColor = _lightColor.CGColor;
    
    CGColorRef darkColor = _darkColor.CGColor;
    
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 
                              
                                             blue:0.2 alpha:0.5].CGColor;  
    
    
    
    CGContextSetFillColorWithColor(contextRef, whiteColor);
    
    CGContextFillRect(contextRef, rect);  //填充底图，用于映衬上面的阴影部分
    
    
    
    
    
    CGContextSaveGState(contextRef);
    
    /*
     
     设置阴影部分
     
     参数2.阴影相对于主体的偏移
     
     参数3.阴影的模糊度
     
     */
    
    CGContextSetShadowWithColor(contextRef, CGSizeMake(0, 2), 3, shadowColor); 
    
    /*
     
     主体颜色填充
     
     */
    
    CGContextSetFillColorWithColor(contextRef, lightColor);
    
    /*
     
     填充颜色
     
     */
    
    CGContextFillRect(contextRef, _coloredBoxRect);
    
    CGContextRestoreGState(contextRef);
    
    
    
    /*
     
     玻璃效果
     
     */
    
    drawGlossAndGradient1(contextRef, _coloredBoxRect, lightColor, darkColor);
    
    
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
}




@end
