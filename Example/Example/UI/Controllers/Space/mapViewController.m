//
//  mapViewController.m
//  Example
//
//  Created by wangwb on 13-1-15.
//  Copyright (c) 2013年 szty. All rights reserved.
//

#import "mapViewController.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#define span1 40000
@interface mapViewController ()
{
    NSMutableArray *_annotationList;
    
    CalloutMapAnnotation *_calloutAnnotation;
	CalloutMapAnnotation *_previousdAnnotation;
    
}
-(void)setAnnotionsWithList:(NSArray *)list;
@end

@implementation mapViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _annotationList = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
//    _mapview.showsUserLocation = YES;
//  
//    CLLocationCoordinate2D theCoordinate = {39.91234846,116.454018};
// 
//    
//    //（3）设定显示范围
//    MKCoordinateSpan theSpan;
//    theSpan.latitudeDelta=0.02;
//    theSpan.longitudeDelta=0.02;
//    
//    //（4）设置地图显示的中心及范围
//    MKCoordinateRegion theRegion;
//    theRegion.center=theCoordinate;
//    theRegion.span=theSpan;
//    
//    //（5）设置地图显示的类型及根据范围进行显示
//    [_mapview setRegion:theRegion];
//    [_mapview setMapType:MKMapTypeStandard];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAnnotionsWithList:_annotationList];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mapview release];
    [_annotationList release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapview:nil];
    [super viewDidUnload];
}
-(void)setAnnotionsWithList:(NSArray *)list
{
    for (NSDictionary *dic in list) {
        
        CLLocationDegrees latitude=[[dic objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude=[[dic objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span1 ,span1 );
        MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:region];
        [_mapview setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude]  autorelease];
        [_mapview   addAnnotation:annotation];
    }
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        if (_calloutAnnotation) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
        _calloutAnnotation = [[[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude] autorelease];
        [mapView addAnnotation:_calloutAnnotation];
        
        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
	}
    else{
        if([delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
            [delegate customMKMapViewDidSelectedWithInfo:@"点击至之后你要在这干点啥"];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutAnnotation];
            _calloutAnnotation = nil;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        
        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"] autorelease];
            JingDianMapCell  *cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            [annotationView.contentView addSubview:cell];
            
        }
        return annotationView;
	} else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        MKAnnotationView *annotationView =[self.mapview dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"] autorelease];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"pin.png"];
        }
		
		return annotationView;
    }
	return nil;
}
- (void)resetAnnitations:(NSArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];

}

@end
