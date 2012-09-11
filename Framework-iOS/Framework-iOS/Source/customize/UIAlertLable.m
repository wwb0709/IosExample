//
//  UIAlertLable.m
//  AiHao
//
//  Created by wwb on 12-8-2.
//  Copyright (c) 2012年 szty. All rights reserved.
//



#import "UIAlertLable.h"

#define kTablePadding 8.0f

@interface UIAlertView (private)
- (void)layoutAnimated:(BOOL)fp;
@end

@implementation UIAlertLable


@synthesize cotentHeight;
@synthesize cotentLable;
@synthesize content;

- (void)layoutAnimated:(BOOL)fp {
    [super layoutAnimated:fp];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - cotentExtHeight / 2, self.frame.size.width, self.frame.size.height + cotentExtHeight)];
    UIView *lowestView;
    int i = 0;
    while (![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]]) {
        lowestView = [self.subviews objectAtIndex:i];
        i++;
    }    
    CGFloat cotentWidth = 240.0f;    
    cotentLable.frame = CGRectMake(25.0f, lowestView.frame.origin.y + lowestView.frame.size.height + 2 * kTablePadding, cotentWidth, cotentHeight);    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIControl class]]) {
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y + cotentExtHeight, v.frame.size.width, v.frame.size.height);
        }
    }    
}

- (void)show{
    [self prepare];
    [super show];
}

- (void)prepare {
  
    cotentLable = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    cotentLable.backgroundColor = [UIColor clearColor];
    cotentLable.text = content;
    cotentLable.font = [UIFont boldSystemFontOfSize:18];
    cotentLable.textColor = [UIColor whiteColor];
    NSInteger	tlines=	[UIAlertLable getLinesWithText:content textFont:[UIFont boldSystemFontOfSize:18] rectWidth:240 lineBreakMode:UILineBreakModeWordWrap];
    int lines =	(tlines<=1 ? 1:tlines);
    cotentLable.numberOfLines = lines;
    cotentHeight = lines*[content sizeWithFont:[UIFont boldSystemFontOfSize:18]].height;       
    [self insertSubview:cotentLable atIndex:0];    
    [self setNeedsLayout];
    
    if (cotentHeight == 0) {
        cotentHeight = 150.0f;
    }    
    cotentExtHeight = cotentHeight + 2 * kTablePadding;  
}

- (void)dealloc {
    [content release];
    [cotentLable release];
    [super dealloc];
}
+ (NSInteger) getLinesWithText:(NSString*)			txt 
					  textFont:(UIFont*)			font
					 rectWidth:(CGFloat)			width
				 lineBreakMode:(UILineBreakMode)	mode
{
	if (nil==txt || nil==font)
		return 0;
	NSInteger	lins=		0;
	CGFloat	maxHeight=		500;
	CGSize sizeForHeight=	[txt sizeWithFont:font];
	CGSize sizeForLines=	[txt sizeWithFont:font constrainedToSize:CGSizeMake(width, maxHeight) lineBreakMode:mode];
	
	lins= ceil(sizeForLines.height/sizeForHeight.height);	
	return lins;
}
@end