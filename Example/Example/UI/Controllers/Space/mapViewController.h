//
//  mapViewController.h
//  Example
//
//  Created by wangwb on 13-1-15.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MapKit/MKPlacemark.h>
#import <MapKit/MapKit.h>
@protocol MapViewControllerDidSelectDelegate; 
@interface mapViewController : UIViewController<MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mapview;
@property(nonatomic,assign)id<MapViewControllerDidSelectDelegate> delegate;

- (void)resetAnnitations:(NSArray *)data;
@end

@protocol MapViewControllerDidSelectDelegate <NSObject>

@optional
- (void)customMKMapViewDidSelectedWithInfo:(id)info;

@end

