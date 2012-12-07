//
//  testFtpViewController.h
//  Example
//
//  Created by wangwb on 12-12-5.
//  Copyright (c) 2012年 szty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FTPHelper.h"
@interface testFtpViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,FTPHelperDelegate>
{
	BOOL isCamera;
    BOOL isSending;
    NSURL *targetURL;
}
- (IBAction)chosePic:(id)sender;
- (IBAction)sendPic:(id)sender;
- (IBAction)startCamera:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *sendStatu;
@property (retain, nonatomic) IBOutlet UIImageView *chosedImage;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentVideoQuality;

@end
