//
//  ShakingAlertView.m
//
//  Created by Luke on 21/09/2012.
//  Copyright (c) 2012 Luke Stringer. All rights reserved.
//
//  https://github.com/stringer630/ShakingAlertView
//

//  This code is distributed under the terms and conditions of the MIT license.
//
//  Copyright (c) 2012 Luke Stringer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ShakingAlertView.h"
#include <CommonCrypto/CommonDigest.h>



@interface ShakingAlertView ()
// Private property as other instances shouldn't interact with this directly
@property (nonatomic, strong) UITextField *passwordField;
@end

// Enum for alert view button index
typedef enum {
    ShakingAlertViewButtonIndexDismiss = 0,
    ShakingAlertViewButtonIndexSuccess = 10
} ShakingAlertViewButtonIndex;

@implementation ShakingAlertView
@synthesize onEnter,onCancel;
#pragma mark - Constructors

- (id)initWithAlertTitle:(NSString *)title{
    
    self = [super initWithTitle:title     
                        message:@"---blank---" // password field will go here
                       delegate:self 
              cancelButtonTitle:@"取消" 
              otherButtonTitles:@"确定", nil];
    if (self) {

    }

    return self;
}

- (id)initWithAlertTitle:(NSString *)title
       onEnter:(void (^)())enter onCancel:(void (^)())cancel
{
    
    self = [self initWithAlertTitle:title];
    if (self) {
        self.onEnter = enter;
        self.onCancel = cancel;
    }
    
    
    return self;
    
}


// Override show method to add the password field
- (void)show {
    
    // Textfield for the password
    // Position it over the message section of the alert
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(14, 45, 256, 25)];
    //passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"输入名字";
    passwordField.backgroundColor = [UIColor whiteColor];
    
    // Pad out the left side of the view to properly inset the text
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 19)];
    passwordField.leftView = paddingView;
    [paddingView release];
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    // Set delegate
    passwordField.delegate = self;
    
    // Set as property
    self.passwordField = passwordField;
    [passwordField release];

    // Add to subview
    [self addSubview:_passwordField];
    
    // Show alert
    [super show];
    
    // present keyboard for text entry
    [_passwordField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1]; 
    
}

- (void)animateIncorrectPassword {
    // Clear the password field
    _passwordField.text = nil;
    
    // Animate the alert to show that the entered string was wrong
    // "Shakes" similar to OS X login screen
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate left
        self.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            // Translate right
            self.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                // Translate left
                self.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    // Translate to origin
                    self.transform = resetTransform;
                }];
            }];
            
        }];
    }];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // If "Enter" button pressed on alert view then check password
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
      
            self.password = self.passwordField.text;
            // Hide keyboard
            [self.passwordField resignFirstResponder];
            
            // Dismiss with success
//            [alertView dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
           self.onEnter(self.password );
            
     
    }
    else
    {
//         [alertView dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexDismiss animated:YES];
        self.onCancel();

    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    // Check password
    
        

    self.password = self.passwordField.text;
    // Hide keyboard
    [self.passwordField resignFirstResponder];
    

    self.onEnter(self.password );
        // Dismiss with success
//        [self dismissWithClickedButtonIndex:ShakingAlertViewButtonIndexSuccess animated:YES];
    
        return YES;

}



#pragma mark - Memory Managment
- (void)dealloc {
    [_passwordField release];
    [_password release];
    [self.onEnter release];
    [self.onCancel release];
    
    [super dealloc];
}


@end
