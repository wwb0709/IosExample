//
//  CustomTabBar.m
//  AiHao
//
//  Created by wwb on 12-6-21.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "CustomTabBar.h"


@implementation CustomTabBar

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize images;

- (id)initWithImageArray:(NSArray *)arr
{
    self = [super init];
	if (self != nil)
	{
        images = arr;
        self.currentSelectedIndex = 0;
    }
    return self;

}

- (void)viewDidAppear:(BOOL)animated{
    slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbg.png"]];
    [self hideRealTabBar];
    [self customTabBar];
}

- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
}

- (void)customTabBar{
    UIImageView *imgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"dilanbg.png"]];
    imgView.frame = CGRectMake(0, 480-kTabBarHeight, 320, kTabBarHeight);
    imgView.tag = 10;
    [self.view addSubview:imgView];
  

    
    slideBg.frame = CGRectMake(0, self.tabBar.frame.origin.y, slideBg.image.size.width, slideBg.image.size.height/4);
    
  
    
    //创建按钮
    int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    double _width = 320 / viewCount;
    double _height = self.tabBar.frame.size.height;
    
    //在工具条按钮上添加点击事件
    for (int i = 0; i < viewCount; i++) {
        UIImageView * igView = [[UIImageView alloc] initWithImage:nil];
        igView.frame = CGRectMake(i*_width,self.tabBar.frame.origin.y, _width, _height);
        igView.tag = i+100;
        igView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [igView addGestureRecognizer:singleRecognizer];
        
        [self.view  addSubview:igView];
        [igView release];
    }
    

    for (int i = 0; i < viewCount; i++) {
        
        UIImageView * igView = [[UIImageView alloc] initWithImage:[images objectAtIndex:i]];
        igView.frame = CGRectMake(i*_width,self.tabBar.frame.origin.y, _width, _height);
        igView.tag = i+1000;
        igView.userInteractionEnabled = YES;
        igView.hidden = YES;
        [self.buttons addObject:igView];
        [self.view  addSubview:igView];
        [igView release];

    }
    //[self.view addSubview:slideBg];
    UIImageView * igView = [self.buttons objectAtIndex:self.currentSelectedIndex];
    self.selectedIndex = igView.tag-1000;
    igView.hidden = NO;
}

-(void)handleSingleTapFrom:(id)sender
{
    NSInteger index = [(UIGestureRecognizer *)sender view].tag;//获
    for (UIImageView *igView in self.buttons) {
        int t = igView.tag;
        if (t==(index+900)) {
            if (self.currentSelectedIndex == (igView.tag-1000)) {
                [[self.viewControllers objectAtIndex:(igView.tag-1000)] popToRootViewControllerAnimated:YES];
            }
            self.currentSelectedIndex =igView.tag-1000;
            self.selectedIndex = self.currentSelectedIndex;
            igView.hidden = NO;
            //[self performSelector:@selector(slideTabBg:) withObject:igView];
        }
        else
        {
            igView.hidden = YES;
        }
    }
    
    

}
- (void)selectedTabWithIndex:(int)index
{
     self.currentSelectedIndex = index;
}


- (void)slideTabBg:(UIImageView *)btn{
    [UIView beginAnimations:nil context:nil];  
    [UIView setAnimationDuration:0.20];  
    [UIView setAnimationDelegate:self];
    slideBg.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, slideBg.image.size.width, slideBg.image.size.height/4);
    [UIView commitAnimations];
}

- (void) dealloc{
    [slideBg release];
    [buttons release];
    images = nil;
    [super dealloc];
}
@end
