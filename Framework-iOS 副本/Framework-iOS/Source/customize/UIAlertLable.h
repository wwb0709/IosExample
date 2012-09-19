//
//  UIAlertLable.h
//  AiHao
//
//  Created by wwb on 12-8-2.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIAlertView;

@interface UIAlertLable : UIAlertView {
    UIAlertView *alertView;
    UILabel *cotentLable;
    int cotentHeight;
    int cotentExtHeight;
    NSString *content;
}

@property (nonatomic, readonly) UILabel *cotentLable;
@property (nonatomic, assign) int cotentHeight;
@property (nonatomic, retain) NSString *content;
- (void)prepare;

+ (NSInteger) getLinesWithText:(NSString*)			txt 
textFont:(UIFont*)			font
rectWidth:(CGFloat)			width
                 lineBreakMode:(UILineBreakMode)	mode;

@end