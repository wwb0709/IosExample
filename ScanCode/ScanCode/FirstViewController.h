//
//  FirstViewController.h
//  ScanCode
//
//  Created by wangwb on 12-12-18.
//  Copyright (c) 2012年 wangwb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *textFiled;
@property (retain, nonatomic) IBOutlet UIImageView *image;
- (IBAction)didEnd:(id)sender;

- (IBAction)InputString:(id)sender;
@end
