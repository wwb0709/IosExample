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
    //键盘释放
    [_textFiled resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self.view];
//    CGRect imageRect = CGRectMake(0, 0, _image.frame.size.width,  _image.frame.size.height);
    if([touch tapCount] == 2&&CGRectContainsPoint(_image.frame,point))
    {
      
        NSLog(@"single click %@",[_image image]);
        NSLog(@"single click %@",[_image image]);
        
        UIImageWriteToSavedPhotosAlbum([_image image], nil, nil, nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                              
                                                        message:@"您已将照片存储于图片库中，打开照片程序即可查看。"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil];
        
        [alert show];
        
        [alert release];
        
    }
    
}
@end
