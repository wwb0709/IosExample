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
#import "AppDelegate.h"
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
@synthesize delegate,onEnter,onCancel;
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
    _mapview.showsUserLocation = YES;
  
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
    
    
//    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
//    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
//    lpress.allowableMovement = 10.0;
//    [_mapview addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
//    [lpress release];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [_mapview addGestureRecognizer:mTap];
    [mTap release];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self setAnnotionsWithList:_annotationList];
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
        
//        //（3）设定显示范围
//        MKCoordinateSpan theSpan;
//        theSpan.latitudeDelta=0.02;
//        theSpan.longitudeDelta=0.02;
//        
//        //（4）设置地图显示的中心及范围
//        MKCoordinateRegion theRegion;
//        theRegion.center=theCoordinate;
//        theRegion.span=theSpan;
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,span1 ,span1 );
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta=0.02;
        theSpan.longitudeDelta=0.02;
        region.span  = theSpan;
        MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:region];
        [_mapview setRegion:adjustedRegion animated:YES];
        
        BasicMapAnnotation *  annotation=[[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude]  autorelease];
        annotation.title = [dic objectForKey:@"name"];
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
        BasicMapAnnotation *annotation = view.annotation;
        _calloutAnnotation = [[[CalloutMapAnnotation alloc]
                               initWithLatitude:view.annotation.coordinate.latitude
                               andLongitude:view.annotation.coordinate.longitude andName:annotation.title] autorelease];
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
            cell.tag = 111111;
            [annotationView.contentView addSubview:cell];
            
        }
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;

        JingDianMapCell  *cell = (JingDianMapCell*)[annotationView.contentView viewWithTag:111111];
        cell.name.text = ann.name;
        
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


- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
//    if (_calloutAnnotation) {
//        [_mapview removeAnnotation:_calloutAnnotation];
//        _calloutAnnotation = nil;
//    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapview];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapview convertPoint:touchPoint toCoordinateFromView:_mapview];//这里touchMapCoordinate就是该点的经纬度了
    
    float longtitude = touchMapCoordinate.longitude;
    
    float latitude = touchMapCoordinate.latitude;
    
    if (longtitude<0||latitude<0) {
        return;
    }
    NSLog(@"---current tap longtitude%@",[NSString stringWithFormat:@"%f",longtitude]);
    NSLog(@"---current tap latitude%@",[NSString stringWithFormat:@"%f",latitude]);
    
    
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",latitude],@"latitude",[NSString stringWithFormat:@"%f",longtitude],@"longitude",nil];
//    [_annotationList addObject:dic];
//    [self setAnnotionsWithList:_annotationList];
   
   
    self.onEnter =^(NSString *txt){
        if (txt.length>0) {
             NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
            [mutableDic setDictionary:dic];
            [mutableDic setObject:txt forKey:@"name"];
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate.g_laopai addObject:mutableDic];
            [mutableDic release];
            [self setAnnotionsWithList:delegate.g_laopai];
        }
    };
    self.onCancel = ^(void){};
    ShakingAlertView *alert = [[ShakingAlertView alloc] initWithAlertTitle:@"输入名称" onEnter:self.onEnter onCancel:self.onCancel] ;
   
    [alert show];
    


    
    //[alert release];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置"
//                                                    message:nil
//                                                   delegate:nil
//                                          cancelButtonTitle:@"取消"
//                                          otherButtonTitles:@"添加",nil];
//    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
//        NSLog(@"%d",buttonIndex);
//   
//        if (buttonIndex == 1) {
//            
//            
//            
////            UIGraphicsBeginImageContext(self.view.bounds.size);
////            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
////            UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
////            
////            UIGraphicsEndImageContext();
////            NSLog(@"image:%@",image);
////        
////            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//            
//            
//            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            [delegate.g_laopai addObject:dic];
//            [self setAnnotionsWithList:delegate.g_laopai];
//        }
//
//    }];
    

}


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSString *lat=[[NSString alloc] initWithFormat:@"%f",userLocation.coordinate.latitude];
    
    NSString *lng=[[NSString alloc] initWithFormat:@"%f",userLocation.coordinate.longitude];
    
    
    NSLog(@"current tap longtitude%@",lng);
    NSLog(@"current tap latitude%@",lat);


    if (userLocation.coordinate.latitude<0||userLocation.coordinate.longitude<0) {
        return;
    }
    
    
    MKCoordinateSpan span;
    
    MKCoordinateRegion region;
    
    
    
    span.latitudeDelta=0.02;
    span.longitudeDelta=0.02;
    
    region.span=span;
    
    region.center=[userLocation coordinate];
    
    
    
    
    
    [_mapview setRegion:[_mapview regionThatFits:region] animated:YES];
    
    
    
}

@end
