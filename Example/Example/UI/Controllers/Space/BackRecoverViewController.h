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
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>  
#import "mapViewController.h"
@interface BackRecoverViewController : UIViewController<CLLocationManagerDelegate,MapViewControllerDidSelectDelegate>
{
    HTTPServer *httpServer;
  
}
@property (nonatomic, retain) CLLocationManager       *locationManager;
- (IBAction)backAddressBook:(id)sender;
- (IBAction)recoverAddressBook:(id)sender;

@end
