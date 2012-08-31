//
//  MyString.h
//  TextGlowDemo
//
//  Created by wwb on 12-8-28.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyString : UIView
{
    int len;
    NSString *text;
    int hight;
    int linenum;
    NSTimer *t;
}
-(void)settext:(NSString *)t;
@end
