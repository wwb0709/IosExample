//
//  AnimalLabelViewController.m
//  Example
//
//  Created by wangwb on 12-12-17.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import "AnimalLabelViewController.h"
#define kMaxTranslation 190.0f
@interface AnimalLabelViewController ()
{
    CGFloat sliderInitialX;
}
@end

@implementation AnimalLabelViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc {
//    [_animatedLabel release];
//    [_slider release];
//    [super dealloc];
//}
//- (void)viewDidUnload {
//    [self setAnimatedLabel:nil];
//    [self setSlider:nil];
//    [super viewDidUnload];
//}

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

    //[userIDLabel startAnimating];

    
    
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
