//
//  WallitLoginViewController.h
//  WallitClient
//
//  Created by huanhuan sui on 12-5-21.
//  Copyright (c) 2012年 Huawei Tec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHHLoginViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *textName;
    UITextField *textPassword;
    UIButton *bindBtn;
    
    UINavigationBar *bar;
}

- (void) loginBtnAction;

@end
