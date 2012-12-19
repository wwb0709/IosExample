//
//  jsTestViewController.h
//  jsTest
//
//  Created by Leisure on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jsTestViewController : UIViewController<UIWebViewDelegate>

// 显示的webview
@property (retain, nonatomic) IBOutlet UIWebView *showWebview;


// 标记是OC调用JS 还是JS调用OC
@property (nonatomic,assign)BOOL isOC2JS;
- (IBAction)AddLine:(id)sender;

// js调用后，oc处理调用的函数
- (void)showAlertWithString:(NSString *)string;
@end
