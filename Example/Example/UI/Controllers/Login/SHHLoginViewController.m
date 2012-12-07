//
//  WallitLoginViewController.m
//  WallitClient
//
//  Created by huanhuan sui on 12-5-21.
//  Copyright (c) 2012年 Huawei Tec. All rights reserved.
//

#import "SHHLoginViewController.h"
#import "NSNotificationAdditions.h"
//#import "ProjectApplication.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHHLoginViewController

- (id) init
{
    if (!(self = [super init]))
        return nil;
    
    self.title = @"登录";
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg640X960"]];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"登录"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(loginBtnAction)];
    if ([rightButton respondsToSelector:@selector(tintColor)])
    {
        rightButton.tintColor = [UIColor brownColor];
    }
    
    //设置导航栏内容
    [navigationItem setTitle:@"用户登录"];
    [navigationItem setRightBarButtonItem:rightButton];
    [bar pushNavigationItem:navigationItem animated:NO];

    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 50, 300, 195)];
    backGroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView* labelName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg581X172"]];
    labelName.userInteractionEnabled = YES;
    [labelName setFrame:CGRectMake(0, 15, 289, 86)];
    
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegister setImage:[UIImage imageNamed:@"bt578X85"] forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(pushRegisterView:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegister setFrame:CGRectMake(0, 110, 289, 43)];
    
    textName = [[UITextField alloc] initWithFrame:CGRectMake(15, 23, 280, 35)];
    textName.borderStyle = UITextBorderStyleRoundedRect;//设置文本框边框风格
    textName.autocorrectionType = UITextAutocorrectionTypeYes;//启用自动提示更正功能
    textName.placeholder = @"请输入用户名";//设置默认显示文本
    textName.returnKeyType = UIReturnKeyDone;//设置键盘完成按钮，相应的还有“Return”"Gｏ""Google"等
    textName.clearButtonMode = UITextFieldViewModeWhileEditing;
    textName.borderStyle = UITextBorderStyleNone; 
    [textName setBackgroundColor:[UIColor clearColor]];
    [textName setTextColor:[UIColor blackColor]];
    [textName setDelegate:self];
    
    textPassword = [[UITextField alloc] initWithFrame:CGRectMake(15, 68, 280, 35)];
    textPassword.borderStyle = UITextBorderStyleRoundedRect;//设置文本框边框风格
    textPassword.autocorrectionType = UITextAutocorrectionTypeYes;//启用自动提示更正功能
    textPassword.placeholder = @"请输入密码";//设置默认显示文本
    textPassword.returnKeyType = UIReturnKeyDone;//设置键盘完成按钮，相应的还有“Return”"Gｏ""Google"等
    textPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    textPassword.secureTextEntry = YES;
    textPassword.borderStyle = UITextBorderStyleNone; 
    textPassword.backgroundColor = [UIColor clearColor];
    [textPassword setTextColor:[UIColor blackColor]];
    [textPassword setDelegate:self];
    
    [backGroundView addSubview:labelName];
    [backGroundView addSubview:btnRegister];
    [backGroundView addSubview:textName];
    [backGroundView addSubview:textPassword];
    
    [self.view addSubview:backGroundView];
    [self.view addSubview:bar];
    
    //[textName becomeFirstResponder];
    
    [labelName release];
    [backGroundView release];
    [rightButton release];
}

- (void) dealloc
{
    [super dealloc];
    [textName release];
    [textPassword release];
    [bar release];
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([bar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
    {
        [bar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [bar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"]];
    }
}

- (void) loginBtnAction
{
   NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:nil, @"ret", nil];
   [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:@"LoginSuccessful"
                                                                                object:self
                                                                              userInfo:info];
//    NSString *name = textName.text;
//    NSString *pass = textPassword.text;
//    
//    if (nil != name && 0 != name.length &&
//        nil != pass && 0 != pass.length)
//    {
//        NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:nil, @"ret", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:@"LoginSuccessful"
//                                                                            object:self
//                                                                          userInfo:info];
//    }
//    // 当用户为空时直接点击登录按钮，需要弹出提示框提示用户
//    else
//    {
//        NSString *msg;
//        if(nil == name || 0 == name.length)
//        {
//            msg = @"用户名不能为空";
//        }
//        else
//        {
//            msg = @"密码不能为空";
//        }
//        UIAlertView *loginAlertView;
//        loginAlertView = [[UIAlertView alloc] initWithTitle:@"错误提示"
//                                                    message:msg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//        [loginAlertView show];
//        [loginAlertView release];
//        [msg release];
//        
//    }

}

#pragma mark - 点击done按钮触发的事件
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{ 
    // 如果是输入密码的时候点击done按钮，直接登录
    if(textField.secureTextEntry == YES)
    {
        [self loginBtnAction];
    }
    // 如果是输入用户名的时候点击done按钮，光标跳转到密码输入框
    else
    {
        [textPassword becomeFirstResponder];
    }
    return NO;
}


// 密码或者用户名为空时，点击提示框的确认按钮，光标返回的相应的位置。 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = textName.text;
    if(nil == name || name.length == 0)
    {
        [textName becomeFirstResponder];
    }
    else
    {
        [textPassword becomeFirstResponder];
    }
}

@end
