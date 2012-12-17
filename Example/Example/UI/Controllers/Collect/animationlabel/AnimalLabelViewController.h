//
//  AnimalLabelViewController.h
//  Example
//
//  Created by wangwb on 12-12-17.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTAnimatedLabel.h"
@interface AnimalLabelViewController : UIViewController
@property (retain, nonatomic) IBOutlet MTAnimatedLabel *animatedLabel;
@property (retain, nonatomic) IBOutlet UIImageView *slider;

@end
