//
//  AppDelegate.h
//  LocationBackgroud
//
//  Created by wangwb on 13-1-15.
//  Copyright (c) 2013年 wangwb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>
#import "mapViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,MapViewControllerDidSelectDelegate>
{
    double m_lat;
    double m_lon;
    NSString * m_name;
}
@property (nonatomic, retain) CLLocationManager       *m_locationmanager;
@property (nonatomic, retain) NSMutableArray* g_laopai;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign)  BOOL inBackground;



@end
