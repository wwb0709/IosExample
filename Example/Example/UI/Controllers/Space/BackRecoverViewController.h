//
//  BackRecoverViewController.h
//  Example
//
//  Created by wangwb on 13-1-14.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAdresses.h"
@interface BackRecoverViewController : UIViewController
{
    HTTPServer *httpServer;
}
- (IBAction)backAddressBook:(id)sender;
- (IBAction)recoverAddressBook:(id)sender;

@end
