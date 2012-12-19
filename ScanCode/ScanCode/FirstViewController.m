//
//  FirstViewController.m
//  ScanCode
//
//  Created by wangwb on 12-12-18.
//  Copyright (c) 2012年 wangwb. All rights reserved.
//

#import "FirstViewController.h"
#import "QRCodeGenerator.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"编码", @"编码");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_image release];
    [_textFiled release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImage:nil];
    [self setTextFiled:nil];
    [super viewDidUnload];
}
- (IBAction)didEnd:(id)sender {
    //键盘释放
    [_textFiled resignFirstResponder];
}

- (IBAction)InputString:(id)sender {
  _image.image = [QRCodeGenerator qrImageForString:_textFiled.text imageSize:_image.bounds.size.width];
}
@end
