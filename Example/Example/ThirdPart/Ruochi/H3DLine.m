//
//  H3DLine.m
//  DigitAlbum
//
//  Created by  on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "H3DLine.h"

@implementation H3DLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();	
    //CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);	//Set the width of the pen mark	CGContextSetLineWidth(context, 5.0);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);	//Define a rectangle	
    CGContextAddRect(context, CGRectMake(0, 0, self.bounds.size.width, 1.0));	//Draw it
	CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, CGRectMake(0, 1.0, self.bounds.size.width, 1.0));	//Draw it	
    CGContextFillPath(context);
}


@end
