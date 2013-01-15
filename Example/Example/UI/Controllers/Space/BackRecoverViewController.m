//
//  BackRecoverViewController.m
//  Example
//
//  Created by wangwb on 13-1-14.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "BackRecoverViewController.h"
#import "SysAddrBookManager.h"


@interface BackRecoverViewController ()

@end

@implementation BackRecoverViewController
@synthesize locationManager;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setPort:8081];
	[httpServer setName:@"Example"];
    [httpServer setDocumentRoot:[NSURL fileURLWithPath:[DAUtility getVcfDir]]];

    NSError *error;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startUpdateLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAddressBook:(id)sender {
    
//    mapViewController *controller =  [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
//    [self.navigationController pushViewController:controller animated:NO];
//    
    
    
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"30.281843",@"latitude",@"120.102193",@"longitude",nil];
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:@"30.290144",@"latitude",@"120.146696‎",@"longitude",nil];
    
    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"30.248076",@"latitude",@"120.164162‎",@"longitude",nil];
    
    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:@"30.425622",@"latitude",@"120.299605",@"longitude",nil];
    
    NSArray *array = [NSArray arrayWithObjects:dic1,dic2,dic3,dic4, nil];
    
	mapViewController *controller =  [[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
    controller.delegate = self;
    

    
    [controller resetAnnitations:array];
    [self.navigationController pushViewController:controller animated:NO];
   
    //[SysAddrBookManager createVcard];
}

- (IBAction)recoverAddressBook:(id)sender {
    NSString *filePath = @"/Users/wwb/Library/Application Support/iPhone Simulator/6.0/Applications/E0337306-29E1-420D-AE3D-E253CFDBC64B/Documents/vcf/20130114165616.vcf";
    [SysAddrBookManager recoverAddressBookFormVcard:filePath];
}

- (void)dealloc {
	[httpServer release];
    [super dealloc];
}
#pragma mark self location
-(void)startUpdateLocation
{
        if (!self.locationManager) {
            CLLocationManager* theManager = [[[CLLocationManager alloc] init] autorelease];
            
            // Retain the object in a property.
            self.locationManager = theManager;
            locationManager.delegate = self;
        }
        
        // Start location services to get the true heading.
    if ([locationManager locationServicesEnabled]) {
        
        locationManager.delegate =self;
        
        locationManager.desiredAccuracy  =kCLLocationAccuracyBest;
        
        locationManager.distanceFilter  =1000;
        
        [locationManager startUpdatingLocation];
        
    }
    
    else
        
    {
        
        NSLog(@"location server error!");
        
    }
        
        // Start heading updates.
//        if ([CLLocationManager headingAvailable]) {
//            locationManager.headingFilter = 5;
//            [locationManager startUpdatingLocation];
//        }

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    
    
    float longtitude = loc.longitude;
    
    float latitude = loc.latitude;
    
    
    printLog(@"longtitude%@",[NSString stringWithFormat:@"%f",longtitude]);
    printLog(@"latitude%@",[NSString stringWithFormat:@"%f",latitude]);
  
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for(CLPlacemark *placemark in placemarks)
        {
            NSString *location = [NSString stringWithFormat:@"%@%@  %@",[[placemark.addressDictionary objectForKey:@"City"] substringToIndex:3],[placemark.addressDictionary objectForKey:@"SubLocality"],[placemark.addressDictionary objectForKey:@"Name"]];
            NSLog(@"addressDictionary:%@",placemark.addressDictionary);
            NSLog(@"您的当前位置为:%@",location);
        }
    }];
    
    
    [locationManager stopUpdatingLocation];
    
    
}


- (void)customMKMapViewDidSelectedWithInfo:(id)info
{
    NSLog(@"%@",info);
}
@end
