//
//  AnimalLabelViewController.m
//  Example
//
//  Created by wangwb on 12-12-17.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "AnimalLabelViewController.h"
#import "MarqueeLabel.h"
#define kMaxTranslation 190.0f
@interface AnimalLabelViewController ()
{
    CGFloat sliderInitialX;
}
@end

@implementation AnimalLabelViewController
@synthesize animatedLabel;
@synthesize slider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.slider addGestureRecognizer:pan];
    
    
    
    MTAnimatedLabel *userIDLabel = [[MTAnimatedLabel alloc] initWithFrame:CGRectMake(20, 10, 90, 22)];
    [userIDLabel setFont:[UIFont systemFontOfSize:16]];
    [userIDLabel setBackgroundColor:[UIColor clearColor]];
    [userIDLabel setTextColor:[UIColor grayColor]];
    [userIDLabel setTextAlignment:UITextAlignmentLeft];
    [userIDLabel setText:NSLocalizedString(@"HELLO WORLD", nil)];
    [self.view addSubview:userIDLabel];

    [userIDLabel startAnimating];
    
    
    
    
    MarqueeLabel *rateLabelOne = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 20) rate:50.0f andFadeLength:10.0f];
    rateLabelOne.numberOfLines = 1;
    rateLabelOne.opaque = NO;
    rateLabelOne.enabled = YES;
    rateLabelOne.shadowOffset = CGSizeMake(0.0, -1.0);
    rateLabelOne.textAlignment = UITextAlignmentLeft;
    rateLabelOne.textColor = [UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000];
    rateLabelOne.backgroundColor = [UIColor clearColor];
    rateLabelOne.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.000];
    rateLabelOne.text = @"This is another long label that scrolls at a specific rate, rather than scrolling its length in a specific time window!This text is not as long, but still long enough to scroll, and scrolls the same speed!";
    
    [self.view addSubview:rateLabelOne];
    [rateLabelOne release];


    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.animatedLabel startAnimating];
    sliderInitialX = self.slider.frame.origin.x;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.animatedLabel stopAnimating];
}

- (void)viewDidUnload
{
    [self setAnimatedLabel:nil];
    [self setSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc {
    [super dealloc];
}
- (void)pan:(id)sender {
    UIPanGestureRecognizer *gr = sender;
    if (gr.state == UIGestureRecognizerStateBegan) {
        [self.animatedLabel stopAnimating];
    }
    
    if (gr.state == UIGestureRecognizerStateChanged) {
        
        CGPoint t = [gr translationInView:self.view]; //get Translation
        
        CGRect f = self.slider.frame;
        f.origin.x = MAX(sliderInitialX, MIN(kMaxTranslation, f.origin.x+t.x)); //enforce slider bounds
        self.slider.frame = f;
        
        self.animatedLabel.alpha = 1-(self.slider.frame.origin.x/(kMaxTranslation*0.5 - sliderInitialX)); //calc label alpha
        
        [gr setTranslation:CGPointZero inView:self.view]; //reset translation
        
    }
    
    if (gr.state == UIGestureRecognizerStateEnded) {
        
        
        [UIView animateWithDuration:0.1 animations:^{
            CGRect f = self.slider.frame;
            f.origin.x = sliderInitialX;
            self.slider.frame = f;
        } completion:^(BOOL finished) {
            [self.animatedLabel startAnimating];
            self.animatedLabel.alpha = 1.0f;
        }];
        
    }
}
@end
