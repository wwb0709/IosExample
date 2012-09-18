//
//  UINavigationBarImage.m
//  Example
//
//  Created by wwb on 12-9-18.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "UINavigationBarImage.h"

@implementation UINavigationBar (UINavigationBarImage)
UIImageView *backgroundView;
-(void)setBackgroundImage:(UIImage*)image
{
    self.tintColor = [UIColor brownColor];
    
    if(image == nil)
    {
        [backgroundView removeFromSuperview];
    }
    else
    {
        if (backgroundView != nil)
        {
            // 这里remove的原因是，解决tab页来回切换，navagationItem.left和right按钮被背景图片遮挡
            [backgroundView removeFromSuperview];
        }
        
        backgroundView = [[UIImageView alloc] initWithImage:image];
        backgroundView.tag = 10;
        backgroundView.frame = CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height);
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
        [backgroundView release];
    }
}

//for other views
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    [self sendSubviewToBack:backgroundView];
}
@end