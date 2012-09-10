//
//  UIViewLayout.h
//  ezsong
//
//  Created by  ruochi on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
extern CGFloat const MARGIN_AUTO;

@interface UIView (UIViewLayout)

//-(void)alignRight:(UIView*)aView;
-(void)snapRight:(UIView*)aView offset:(CGFloat)aValue;
-(void)snapLeft:(UIView*)aView offset:(CGFloat)aValue;
-(void)snapTop:(UIView*)aView offset:(CGFloat)aValue;
-(void)snapBottom:(UIView*)aView offset:(CGFloat)aValue;

-(void)alignMiddleOn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignCenterOn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignRightOn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignLeftOn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignTopOn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignBottomOn:(UIView*)aView offset:(CGFloat)aValue;

-(void)alignMiddleIn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignCenterIn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignRightIn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignLeftIn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignTopIn:(UIView*)aView offset:(CGFloat)aValue;
-(void)alignBottomIn:(UIView*)aView offset:(CGFloat)aValue;

-(void)moveX:(CGFloat)x;
-(void)moveY:(CGFloat)y;
-(void)moveX:(CGFloat)x Y:(CGFloat)y;

-(void)verticalStretchIn:(UIView*)aView top:(CGFloat)top bottom:(CGFloat)bottom;
-(void)horizontalStretchIn:(UIView *)aView left:(CGFloat)left right:(CGFloat)right;

-(CGFloat)getLeft;
-(CGFloat)getRight;
-(CGFloat)getTop;
-(CGFloat)getBottom;
-(CGFloat)getWidth;
-(CGFloat)getHeight;





@end
