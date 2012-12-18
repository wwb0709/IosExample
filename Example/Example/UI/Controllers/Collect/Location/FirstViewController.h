//
//  FirstViewController.h
//  City Compass
//
// qing yan
//  xyzs996@gmail.com
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"

#import "FRCurvedTextView.h"


@interface FirstViewController : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate, BSForwardGeocoderDelegate> {
    
    IBOutlet UIScrollView   *compassView;
    CLLocationManager       *locationManager;
    
    CLLocationCoordinate2D  currentLocation;
    CLLocationDirection     currentHeading;
    
    CLLocationCoordinate2D  cityLocation;
    CLLocationDirection     cityHeading;
    
    IBOutlet FRCurvedTextView *labelDestination;
    IBOutlet UISearchBar    *searchBarOutlet;
    IBOutlet UIScrollView   *cityArrowView;
    IBOutlet FRCurvedTextView *cityTextView;
    
    BSForwardGeocoder *forwardGeocoder;

}

@property (nonatomic, retain) IBOutlet UIScrollView *compassView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) CLLocationDirection currentHeading;

@end

