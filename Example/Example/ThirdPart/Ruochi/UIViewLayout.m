//
//  UIViewLayout.m
//  ezsong
//
//  Created by  ruochi on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIViewLayout.h"
#import <math.h>
CGFloat const MARGIN_AUTO = CGFLOAT_MIN;
@implementation UIView (UIViewLayout)

-(void)snapRight:(UIView*)aView offset:(CGFloat)aValue
{
    [self moveX:[aView getRight] + aValue];
    //self.frame = [LayoutUtils move:self.frame alignRightRect:aView.frame offset:aValue];
}
-(void)snapLeft:(UIView*)aView offset:(CGFloat)aValue
{
    [self moveX:[aView getLeft] - self.bounds.size.width + aValue];
    //self.frame = [LayoutUtils move:self.frame alignLeftRect:aView.frame offset:aValue];
}
-(void)snapTop:(UIView*)aView offset:(CGFloat)aValue
{
    [self moveY:[aView getTop] - self.bounds.size.height + aValue];
    //self.frame = [LayoutUtils move:self.frame alignTopRect:aView.frame offset:aValue];
}
-(void)snapBottom:(UIView*)aView offset:(CGFloat)aValue
{
    [self moveY:[aView getBottom] + aValue];
    
    //self.frame = [LayoutUtils move:self.frame alignBottomRect:aView.frame offset:aValue];
}


-(void)alignMiddleOn:(UIView*)aView offset:(CGFloat)aValue
{
    [self moveY:([aView getHeight] - [self getHeight]) /2 + [aView getTop] + aValue];
    //self.frame = [LayoutUtils move:self.frame atMiddle:aView.frame];
}
-(void)alignCenterOn:(UIView*)aView offset:(CGFloat)aValue;
{
    [self moveX:([aView getWidth] - [self getWidth]) /2 + [aView getLeft] + aValue];
    //self.frame = [LayoutUtils move:self.frame atCenter:aView.frame];
}

-(void)alignRightOn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveX:[aView getRight] - [self getWidth] + aValue];
    //self.frame = [LayoutUtils move:self.frame referenceRect:aView.frame left:MARGIN_AUTO right:aValue];
}

-(void)alignLeftOn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveX:[aView getLeft] + aValue];
    
}
-(void)alignTopOn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveY:[aView getTop] + aValue];
    //self.frame = [LayoutUtils move:self.frame referenceRect:aView.frame top:aValue bottom:MARGIN_AUTO];
    
}
-(void)alignBottomOn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveY:[aView getBottom] - [self getHeight] + aValue];
}



-(void)alignMiddleIn:(UIView*)aView offset:(CGFloat)aValue
{
    [self moveY:([aView getHeight] - [self getHeight]) /2  + aValue];
}
-(void)alignCenterIn:(UIView*)aView offset:(CGFloat)aValue;
{
    [self moveX:([aView getWidth] - [self getWidth]) /2 + aValue];}

-(void)alignRightIn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveX:[aView getWidth] - [self getWidth] + aValue];
}

-(void)alignLeftIn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveX:aValue];
    
}
-(void)alignTopIn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveY:aValue];
    
}
-(void)alignBottomIn:(UIView *)aView offset:(CGFloat)aValue
{
    [self moveY:[aView getHeight] - [self getHeight] + aValue];
}


-(void)moveX:(CGFloat)x
{
    self.frame = CGRectMake(roundf(x), self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)moveY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, roundf(y), self.frame.size.width, self.frame.size.height);
}

-(void)moveX:(CGFloat)x Y:(CGFloat)y
{
    self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
}


-(CGFloat)getLeft
{
    return self.frame.origin.x;
}

-(CGFloat)getRight
{
    return self.frame.origin.x + self.frame.size.width;
}
-(CGFloat)getTop
{
    return self.frame.origin.y;
}
-(CGFloat)getBottom
{
    return self.frame.origin.y + self.frame.size.height;
}
-(CGFloat)getHeight
{
    return self.bounds.size.height;
}

-(CGFloat)getWidth
{
    return self.bounds.size.width;
}

-(void)verticalStretchIn:(UIView *)aView top:(CGFloat)top bottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.frame.origin.x, top, self.frame.size.width, aView.bounds.size.height - bottom);
}

-(void)horizontalStretchIn:(UIView *)aView left:(CGFloat)left right:(CGFloat)right
{
    self.frame = CGRectMake(left, self.frame.origin.y, aView.bounds.size.width - right, self.frame.size.height);
}

@end
