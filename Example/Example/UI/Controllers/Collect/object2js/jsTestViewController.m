//
//  jsTestViewController.m
//  jsTest
//
//  Created by Leisure on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "jsTestViewController.h"

@interface jsTestViewController ()

@end

@implementation jsTestViewController
@synthesize showWebview;
@synthesize isOC2JS;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 标记是OC调用JS 还是JS调用OC
    self.isOC2JS = NO;
    NSLog(@"DEBUG: this is %@ Model!",self.isOC2JS ? @"oc-> js" : @"js -> oc");
    
    // 根据选择，调用不同的页面加载
    NSString *path = nil;
    if (self.isOC2JS) {
        path  = [[NSBundle mainBundle] pathForResource:@"oc2js" ofType:@"html"];
        
    }
    else {
        path  = [[NSBundle mainBundle] pathForResource:@"js2oc" ofType:@"html"];
    }
    path  = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    //path = @"http://www.hao123.com";
    // webview加载页面
    NSLog(@"DEBUG: path is %@",path);
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    [self.showWebview loadRequest:[NSURLRequest requestWithURL:url]]; 
    [url release];
}

- (void)viewDidUnload
{
    [self setShowWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{
    [showWebview release];
    [super dealloc];
}

- (void)showAlertWithString:(NSString *)string
{
    UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:@"test" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [showAlert show];
    [showAlert release];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"youdao"]) {
        UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:@"test" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alertView show];
        return NO;
    }

    
    // 根据js返回的参数进行字符串匹配解析，根据解析的结果来调用不同的函数
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@":"];
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSString *funcStr = [urlComps objectAtIndex:1];
        if([funcStr isEqualToString:@"doFunc1"])
        {
            // 调用本地函数1
            //[self showAlertWithString:@"doFunc1"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([funcStr isEqualToString:@"doFunc2"])
        {
            // 调用本地函数2
            [self showAlertWithString:@"doFunc2"];
        }
        return NO;
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"DEBUG:webview did start load");   
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // OC调用js的方法
    if (self.isOC2JS) 
    {
        NSLog(@"DEBUG:webview did finish load");   
        NSString *testString =[showWebview stringByEvaluatingJavaScriptFromString:@"myfun();"];
        NSLog(@"DEBUG:the test JS string is:%@",testString);
        
    }
}

- (IBAction)AddLine:(id)sender {
    
    NSString * js = @" var p = document.createElement('p'); p.innerText = 'new Line';document.body.appendChild(p);";
    [self.showWebview stringByEvaluatingJavaScriptFromString:js];
}
@end
