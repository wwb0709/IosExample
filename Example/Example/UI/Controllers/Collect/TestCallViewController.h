//
//  TestCallViewController.h
//  Example
//
//  Created by wangwb on 12-12-4.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface TestCallViewController : UIViewController
- (IBAction)dial:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *inputPhoneNum;
@property (retain, nonatomic) IBOutlet UILabel *phonenum;
@property (retain, nonatomic) IBOutlet UILabel *dialstatu;
@property (retain, nonatomic) CTCallCenter *callCenter;
- (IBAction)getValue:(id)sender;

@end
